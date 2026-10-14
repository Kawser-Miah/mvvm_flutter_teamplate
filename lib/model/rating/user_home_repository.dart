import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_rating_request.dart';

abstract class UserHomeRepository {
  Future<AppRatingResult> submitAppRating(AppRatingRequest request);
}

final userHomeRepositoryProvider = Provider<UserHomeRepository>((ref) {
  throw UnimplementedError('Initialize userHomeRepositoryProvider in ProviderScope overrides');
});
