import '../../../core/errors/result.dart';
import '../../../model/auth/login_request_model.dart';
import '../../../model/auth/user_model.dart';

abstract class AuthRepository {
  /// On success the tokens are in secure storage and the user is cached.
  Future<Result<UserModel>> login(LoginRequestModel request);
  Future<Result<UserModel>> register(Map<String, dynamic> data);

  /// Clears tokens and the cached user.
  Future<Result<void>> logout();

  /// The cached user from the last sign-in, if any.
  UserModel? get cachedUser;
}
