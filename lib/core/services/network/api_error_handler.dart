import 'dart:convert';
import 'package:dio/dio.dart';

import '../../errors/result.dart';

/// The one place that turns a [DioException] into user-facing text.
/// Used by `guard()` (and therefore by `ResultCallAdapter`).
abstract final class ApiErrorHandler {
  /// Classifies the error so callers can branch on it (see [ErrorKind]).
  static ErrorKind kindOf(DioException error) => switch (error.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.connectionError =>
          ErrorKind.network,
        DioExceptionType.badResponse when error.response?.statusCode == 401 =>
          ErrorKind.unauthorized,
        DioExceptionType.badResponse => ErrorKind.server,
        _ => ErrorKind.unknown,
      };

  static (String, dynamic) handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ('Request timeout. Please try again.', null);

      case DioExceptionType.connectionError:
        return ('No internet connection. Please check your connection.', null);

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response);

      case DioExceptionType.cancel:
        return ('Request cancelled', null);

      // error.message is developer text (e.g. "SocketException: ..."), never
      // shown to users.
      default:
        return ('Something went wrong. Please try again.', null);
    }
  }

  static (String, dynamic) _handleResponseError(Response? response) {
    final statusCode = response?.statusCode ?? 0;
    dynamic data = response?.data;
    String message = '';

    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {}
    }

    if (data is Map) {
      if (data.containsKey('errors') && data['errors'] is Map) {
        final errorsMap = data['errors'] as Map;
        final errors = <String>[];
        errorsMap.forEach((key, value) {
          final field = _formatFieldName(key.toString());
          if (value is List) {
            errors.add("$field: ${value.join(', ')}");
          } else {
            errors.add("$field: $value");
          }
        });
        if (errors.isNotEmpty) message = errors.join('\n');
      }

      if (message.isEmpty) {
        final candidate = data['message'] ?? data['error'] ?? data['detail'];
        if (candidate != null) message = candidate.toString();
      }

      if (message.isEmpty) {
        final errors = <String>[];
        data.forEach((key, value) {
          if (key == 'success' || key == 'status') return;
          final field = _formatFieldName(key.toString());
          if (value is List) {
            errors.add("$field: ${value.join(', ')}");
          } else if (value is Map) {
            errors.add("$field: ${value.toString()}");
          } else {
            errors.add("$field: $value");
          }
        });
        if (errors.isNotEmpty) message = errors.join('\n');
      }
    }

    if (message.isEmpty) {
      message = switch (statusCode) {
        400 => 'Bad request',
        401 => 'Session expired. Please login again.',
        403 => 'Access denied',
        404 => 'Resource not found',
        413 => 'File too large',
        422 => 'Validation error',
        500 || 502 || 503 => 'Server error. Please try again later.',
        _ => 'Something went wrong',
      };
    }

    return (message, data);
  }

  static String _formatFieldName(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((w) => w.isNotEmpty ? '${w[0].toUpperCase()}${w.substring(1)}' : '')
        .join(' ');
  }
}
