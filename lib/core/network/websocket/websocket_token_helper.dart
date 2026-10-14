import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../sp_service/secure_storage_service.dart';
import '../api_endpoints.dart';

class WebSocketTokenHelper {
  final SecureStorageService _storageService;

  WebSocketTokenHelper(this._storageService);

  Future<String?> getAccessToken() async {
    return await _storageService.getAccessToken();
  }

  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _storageService.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        debugPrint('[WebSocketTokenHelper] No refresh token found.');
        return null;
      }

      final dio = Dio(
        BaseOptions(
          baseUrl: ApiEndpoints.baseUrl,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        data: {'refresh_token': refreshToken, 'refresh': refreshToken},
      );

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          response.data is Map) {
        final data = response.data as Map;
        final nested = data['data'] is Map ? data['data'] as Map : null;

        final newAccessToken = (nested?['access_token'] ??
                nested?['access'] ??
                data['access_token'] ??
                data['access'])
            ?.toString();

        final newRefreshToken = (nested?['refresh_token'] ??
                nested?['refresh'] ??
                data['refresh_token'] ??
                data['refresh'])
            ?.toString();

        if (newAccessToken != null && newAccessToken.isNotEmpty) {
          await _storageService.saveAccessToken(newAccessToken);
          if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
            await _storageService.saveRefreshToken(newRefreshToken);
          }
          debugPrint('[WebSocketTokenHelper] Tokens refreshed successfully.');
          return newAccessToken;
        }
      }
      return null;
    } catch (e) {
      debugPrint('[WebSocketTokenHelper] Failed to refresh token: $e');
      return null;
    }
  }
}
