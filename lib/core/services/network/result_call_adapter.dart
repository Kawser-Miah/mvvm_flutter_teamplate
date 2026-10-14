import 'package:retrofit/retrofit.dart';

import '../../errors/result.dart';
import 'repo_guard.dart';

/// Wraps every Retrofit call in [guard], so data sources and repositories
/// never need try/catch.
///
/// Declare it at CLASS level: `@RestApi(callAdapter: ResultCallAdapter)`.
/// A class-level `@UseCallAdapter(...)` is ignored by retrofit_generator,
/// which then looks for a non-existent `Result.fromJson`.
class ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) => guard(
        () async => Result.success(await call()),
        fallback: 'Something went wrong. Please try again.',
      );
}
