import 'app_exception.dart';

/// Why a [Failure] happened, so callers can branch without parsing messages.
enum ErrorKind {
  /// No connection, DNS failure or timeout. The request never got an answer.
  network,

  /// HTTP 401 that survived the token-refresh attempt.
  unauthorized,

  /// Any other non-2xx HTTP response.
  server,

  /// Everything else (parsing, storage, programming errors).
  unknown,
}

/// Outcome of a repository / Retrofit call. Errors never throw past the data
/// layer: [ResultCallAdapter] and [guard] turn them into [Failure].
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;

  const factory Result.error(
    String message, {
    int? statusCode,
    ErrorKind kind,
    dynamic data,
  }) = Failure<T>;

  bool get isSuccess => this is Success<T>;

  /// For `AsyncValue.guard` in view-models: returns the data or throws an
  /// [AppException] carrying the already user-friendly message.
  T getOrThrow() => switch (this) {
        Success(:final data) => data,
        Failure(:final message, :final statusCode) =>
          throw AppException(message, statusCode: statusCode),
      };
}

final class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(
    this.message, {
    this.statusCode,
    this.kind = ErrorKind.unknown,
    this.data,
  });

  /// Safe to show to the user. Never raw exception text.
  final String message;
  final int? statusCode;
  final ErrorKind kind;

  /// Decoded error body, when the server sent one (e.g. field errors).
  final dynamic data;

  bool get isNetworkError => kind == ErrorKind.network;
  bool get isUnauthorized => kind == ErrorKind.unauthorized;

  /// Re-types the failure when passing it up through a different `Result<R>`.
  Failure<R> cast<R>() =>
      Failure<R>(message, statusCode: statusCode, kind: kind, data: data);
}
