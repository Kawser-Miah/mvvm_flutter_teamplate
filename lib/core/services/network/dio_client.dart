import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../secure_storage_service/secure_storage_service.dart';
import 'api_endpoints.dart';
import 'api_interceptor.dart';

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(ref.watch(secureStorageServiceProvider));
});

class DioClient {
  DioClient(SecureStorageService storageService) {
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

    // Order matters: the logger runs after the auth interceptor so it prints
    // the Authorization header actually sent.
    dio.interceptors.addAll([
      ApiInterceptor(storageService, dio),
      if (kDebugMode)
        PrettyDioLogger(requestHeader: true, requestBody: true, compact: true),
    ]);
  }

  late final Dio dio;
}
