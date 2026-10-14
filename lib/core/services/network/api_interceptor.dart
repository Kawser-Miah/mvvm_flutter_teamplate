import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../secure_storage_service/secure_storage_service.dart';
import 'api_endpoints.dart';

/// Adds `Authorization: Bearer <token>` and, on a 401, refreshes the token
/// once and retries. Concurrent 401s share one refresh via [_refreshCompleter].
///
/// Tokens are always read from [SecureStorageService] (no in-memory cache),
/// so a sign-out takes effect for the very next request.
class ApiInterceptor extends Interceptor {
  ApiInterceptor(this._storage, this._dio);

  final SecureStorageService _storage;
  final Dio _dio;
  Completer<String?>? _refreshCompleter;

  static const _retryFlag = 'isRetryRequest';

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isNoAuthEndpoint(options.path)) {
      final token = await _storage.read(SecureKey.accessToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (_shouldSkipTokenRefresh(err)) return handler.next(err);

    // Another request may already have refreshed while this one was in
    // flight: retry with the stored token instead of refreshing again.
    final sentToken = _bearerFrom(err.requestOptions.headers);
    final storedToken = await _storage.read(SecureKey.accessToken);
    if (storedToken != null &&
        storedToken.isNotEmpty &&
        storedToken != sentToken) {
      return _retry(err, storedToken, handler);
    }

    final newToken = await _refreshShared();
    if (newToken == null) return handler.next(err);
    return _retry(err, newToken, handler);
  }

  bool _isNoAuthEndpoint(String path) =>
      ApiEndpoints.noAuthEndpoints.any(path.contains);

  bool _shouldSkipTokenRefresh(DioException err) =>
      err.response?.statusCode != 401 ||
      _isNoAuthEndpoint(err.requestOptions.path) ||
      _bearerFrom(err.requestOptions.headers) == null ||
      err.requestOptions.extra[_retryFlag] == true;

  String? _bearerFrom(Map<String, dynamic> headers) {
    final auth =
        (headers['Authorization'] ?? headers['authorization'])?.toString();
    if (auth == null) return null;
    return auth
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();
  }

  Future<String?> _refreshShared() async {
    final pending = _refreshCompleter;
    if (pending != null) return pending.future;

    final completer = _refreshCompleter = Completer<String?>();
    try {
      final token = await _refreshAccessToken();
      completer.complete(token);
      return token;
    } catch (e, st) {
      debugPrint('[ApiInterceptor] Refresh failed: $e\n$st');
      completer.complete(null);
      return null;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await _storage.read(SecureKey.refreshToken);
    if (refreshToken == null || refreshToken.isEmpty) return null;

    // A bare Dio: going through this interceptor would recurse on a 401.
    final refreshDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
      ),
    );

    try {
      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken, 'refresh_token': refreshToken},
      );
      final data = response.data;
      if (data is! Map) return null;

      final nested = data['data'] is Map ? data['data'] as Map : null;
      final access = (nested?['access_token'] ??
              nested?['access'] ??
              data['access_token'] ??
              data['access'])
          ?.toString();
      final refresh = (nested?['refresh_token'] ??
              nested?['refresh'] ??
              data['refresh_token'] ??
              data['refresh'])
          ?.toString();

      if (access == null || access.isEmpty) return null;
      await _storage.write(access, SecureKey.accessToken);
      if (refresh != null && refresh.isNotEmpty) {
        await _storage.write(refresh, SecureKey.refreshToken);
      }
      return access;
    } on DioException catch (e) {
      // The refresh token itself was rejected: the session is over.
      final status = e.response?.statusCode;
      if (status == 400 || status == 401) await _storage.clear();
      return null;
    }
  }

  Future<void> _retry(
    DioException err,
    String token,
    ErrorInterceptorHandler handler,
  ) async {
    final opts = err.requestOptions
      ..headers['Authorization'] = 'Bearer $token'
      ..extra[_retryFlag] = true;
    try {
      handler.resolve(await _dio.fetch(opts));
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
