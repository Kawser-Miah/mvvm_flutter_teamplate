import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/core/errors/result.dart';
import 'package:guard_well/core/services/network/repo_guard.dart';
import 'package:guard_well/core/services/network/result_call_adapter.dart';

void main() {
  final requestOptions = RequestOptions(path: '/quotes/');

  Failure<T> failureOf<T>(Result<T> result) {
    expect(result, isA<Failure<T>>());
    return result as Failure<T>;
  }

  group('ResultCallAdapter', () {
    test('success passes through', () async {
      final result = await ResultCallAdapter<int>().adapt(() async => 7);
      expect(result, isA<Success<int>>());
      expect((result as Success<int>).data, 7);
    });

    test('connection error maps to the network case', () async {
      final result = await ResultCallAdapter<int>().adapt(
        () => throw DioException.connectionError(
          requestOptions: requestOptions,
          reason: 'SocketException: Failed host lookup',
        ),
      );
      final failure = failureOf(result);
      expect(failure.kind, ErrorKind.network);
      expect(failure.isNetworkError, isTrue);
      expect(failure.message, isNot(contains('SocketException')));
    });

    test('timeout maps to the network case', () async {
      final result = await ResultCallAdapter<int>().adapt(
        () => throw DioException.connectionTimeout(
          requestOptions: requestOptions,
          timeout: const Duration(seconds: 30),
        ),
      );
      expect(failureOf(result).kind, ErrorKind.network);
    });

    test('401 maps to the unauthorized case with status code', () async {
      final result = await ResultCallAdapter<int>().adapt(
        () => throw DioException.badResponse(
          statusCode: 401,
          requestOptions: requestOptions,
          response: Response(
            requestOptions: requestOptions,
            statusCode: 401,
            data: {'detail': 'Token expired'},
          ),
        ),
      );
      final failure = failureOf(result);
      expect(failure.kind, ErrorKind.unauthorized);
      expect(failure.isUnauthorized, isTrue);
      expect(failure.statusCode, 401);
      expect(failure.message, 'Token expired');
    });

    test('other HTTP errors map to server with the server message', () async {
      final result = await ResultCallAdapter<int>().adapt(
        () => throw DioException.badResponse(
          statusCode: 500,
          requestOptions: requestOptions,
          response: Response(requestOptions: requestOptions, statusCode: 500),
        ),
      );
      final failure = failureOf(result);
      expect(failure.kind, ErrorKind.server);
      expect(failure.statusCode, 500);
      expect(failure.message, 'Server error. Please try again later.');
    });

    test('unexpected exception returns the fallback, not the raw text',
        () async {
      final result = await ResultCallAdapter<int>().adapt(
        () => throw StateError('internal detail: db password=hunter2'),
      );
      final failure = failureOf(result);
      expect(failure.kind, ErrorKind.unknown);
      expect(failure.message, 'Something went wrong. Please try again.');
      expect(failure.message, isNot(contains('hunter2')));
    });
  });

  group('guard', () {
    test('a Failure returned by the body passes through untouched', () async {
      final result = await guard<int>(
        () async => const Result.error('Invalid response from server.'),
        fallback: 'fallback',
      );
      expect(failureOf(result).message, 'Invalid response from server.');
    });

    test('uses the caller fallback for unexpected errors', () async {
      final result = await guard<int>(
        () async => throw const FormatException('bad json at 12'),
        fallback: 'Could not load quotes.',
      );
      expect(failureOf(result).message, 'Could not load quotes.');
    });
  });
}
