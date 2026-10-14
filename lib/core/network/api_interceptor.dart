import 'dart:async';
import 'package:dio/dio.dart';
import '../sp_service/secure_storage_service.dart';
import 'api_endpoints.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService _storageService;
  final Dio _dio;

  ApiInterceptor(this._storageService, this._dio);

  static String? _latestAccessToken;
  static DateTime? _lastRefreshedAt;
  static Completer<String?>? _refreshCompleter;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_isNoAuthEndpoint(options.path)) {
      return handler.next(options);
    }
    await _addAuthToken(options);
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldSkipTokenRefresh(err)) {
      return handler.next(err);
    }
    try {
      await _handleTokenRefresh(err, handler);
    } catch (_) {
      handler.reject(err);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  bool _isNoAuthEndpoint(String path) {
    return ApiEndpoints.noAuthEndpoints.any((e) => path.contains(e));
  }

  Future<void> _addAuthToken(RequestOptions options) async {
    final accessToken =
        _latestAccessToken ?? await _storageService.getAccessToken();
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
  }

  String? _extractTokenFromHeaders(Map<String, dynamic> headers) {
    final auth =
        (headers['Authorization'] ?? headers['authorization'])?.toString();
    if (auth == null) return null;
    return auth
        .replaceFirst(RegExp(r'^Bearer\s+', caseSensitive: false), '')
        .trim();
  }

  bool _shouldSkipTokenRefresh(DioException err) {
    final hasAuth = err.requestOptions.headers.containsKey('Authorization') ||
        err.requestOptions.headers.containsKey('authorization');
    return _isNoAuthEndpoint(err.requestOptions.path) ||
        !hasAuth ||
        err.response?.statusCode != 401 ||
        err.requestOptions.extra['isRetryRequest'] == true;
  }

  Future<void> _handleTokenRefresh(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final headerToken = _extractTokenFromHeaders(err.requestOptions.headers);
    final isRecentlyRefreshed = _lastRefreshedAt != null &&
        DateTime.now().difference(_lastRefreshedAt!) <
            const Duration(seconds: 30);
    final activeToken =
        _latestAccessToken ?? await _storageService.getAccessToken();

    if (activeToken != null &&
        headerToken != null &&
        activeToken != headerToken &&
        (isRecentlyRefreshed || headerToken != activeToken)) {
      await _retryOriginalRequest(err, activeToken, handler);
      return;
    }

    final refreshToken = await _storageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return handler.next(err);
    }

    String? newAccessToken;
    if (_refreshCompleter != null) {
      newAccessToken = await _refreshCompleter!.future;
    } else {
      _refreshCompleter = Completer<String?>();
      try {
        newAccessToken = await _refreshAccessToken(refreshToken);
        if (newAccessToken != null) {
          _latestAccessToken = newAccessToken;
          _lastRefreshedAt = DateTime.now();
          await _storageService.saveAccessToken(newAccessToken);
        }
        _refreshCompleter!.complete(newAccessToken);
      } catch (e) {
        _refreshCompleter!.complete(null);
      } finally {
        _refreshCompleter = null;
      }
    }

    if (newAccessToken == null) {
      return handler.next(err);
    }
    await _retryOriginalRequest(err, newAccessToken, handler);
  }

  Future<String?> _refreshAccessToken(String refreshToken) async {
    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: _dio.options.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      final response = await refreshDio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh': refreshToken, 'refresh_token': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          final nested = data['data'] is Map<String, dynamic>
              ? data['data'] as Map<String, dynamic>
              : null;
          final token = nested?['access_token'] ??
              nested?['access'] ??
              data['access_token'] ??
              data['access'];
          final newRefresh = nested?['refresh_token'] ??
              nested?['refresh'] ??
              data['refresh_token'] ??
              data['refresh'];
          if (newRefresh != null && newRefresh.toString().isNotEmpty) {
            await _storageService.saveRefreshToken(newRefresh.toString());
          }
          return token?.toString();
        }
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        await _storageService.deleteTokens();
      }
      return null;
    } on DioException catch (dioErr) {
      final status = dioErr.response?.statusCode;
      if (status == 400 || status == 401) await _storageService.deleteTokens();
      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _retryOriginalRequest(
    DioException err,
    String newAccessToken,
    ErrorInterceptorHandler handler,
  ) async {
    final opts = err.requestOptions;
    opts.headers['Authorization'] = 'Bearer $newAccessToken';
    opts.extra['isRetryRequest'] = true;

    try {
      final clonedRequest = await _dio.fetch(opts);
      handler.resolve(clonedRequest);
    } catch (e) {
      handler.reject(err);
    }
  }
}
