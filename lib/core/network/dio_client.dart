import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../sp_service/secure_storage_service.dart';
import 'api_endpoints.dart';
import 'api_interceptor.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient();
});

class DioClient {
  late final Dio dio;
  final SecureStorageService? storageService;

  DioClient([this.storageService]) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 120),
        receiveTimeout: const Duration(seconds: 120),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint(
            '🌐 [DIO REQ] ${options.method} ${options.baseUrl}${options.path}',
          );
          if (options.queryParameters.isNotEmpty) {
            debugPrint('   🔍 Query: ${options.queryParameters}');
          }
          if (options.data != null) {
            debugPrint('   📦 Data: ${options.data}');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint(
            '✅ [DIO RES ${response.statusCode}] ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (err, handler) {
          debugPrint(
            '❌ [DIO ERR ${err.response?.statusCode ?? 'NO_STATUS'}] ${err.requestOptions.path}: ${err.message}',
          );
          if (err.response?.data != null) {
            debugPrint('   ⚠️ Response Data: ${err.response?.data}');
          }
          return handler.next(err);
        },
      ),
      if (storageService != null) ApiInterceptor(storageService!, dio),
    ]);
  }
}
