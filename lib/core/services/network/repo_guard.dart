import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../errors/result.dart';
import 'api_error_handler.dart';

/// Runs [body] and maps anything it throws to a [Failure]. The single place
/// errors are mapped: `ResultCallAdapter` delegates here, and repositories
/// wrap non-HTTP work (storage, parsing, token checks) in it instead of
/// writing try/catch.
///
/// [body] returns a `Result` itself, so validation failures it returns
/// (e.g. `Result.error('Invalid response from server.')`) pass through as-is.
Future<Result<T>> guard<T>(
  Future<Result<T>> Function() body, {
  required String fallback,
}) async {
  try {
    return await body();
  } on DioException catch (e, st) {
    debugPrint('[Repo] DioException(${e.type}): ${e.message}\n$st');
    final (message, data) = ApiErrorHandler.handleDioError(e);
    return Result.error(
      message,
      statusCode: e.response?.statusCode,
      kind: ApiErrorHandler.kindOf(e),
      data: data,
    );
  } catch (e, st) {
    debugPrint('[Repo] Unexpected: $e\n$st');
    return Result.error(fallback); // never e.toString()
  }
}
