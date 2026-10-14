import 'dart:convert';

import '../../../core/errors/result.dart';
import '../../../core/services/network/repo_guard.dart';
import '../../../core/services/secure_storage_service/secure_storage_service.dart';
import '../../../core/services/sp_service/sp_service.dart';
import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';
import '../../../model/auth/user_model.dart';
import '../data_sources/auth_remote_data_source.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteDataSource, this._secureStorage, this._sp);

  final AuthRemoteDataSource _remoteDataSource;
  final SecureStorageService _secureStorage;
  final SpService _sp;

  @override
  Future<Result<UserModel>> login(LoginRequestModel request) async =>
      _persistSession(await _remoteDataSource.login(request));

  @override
  Future<Result<UserModel>> register(Map<String, dynamic> data) async =>
      _persistSession(await _remoteDataSource.register(data));

  @override
  Future<Result<void>> logout() => guard(() async {
        await _secureStorage.clear();
        await _sp.delete(StorageKey.user);
        return const Result.success(null);
      }, fallback: 'Could not sign out. Please try again.');

  @override
  UserModel? get cachedUser {
    final json = _sp.read<String>(StorageKey.user);
    if (json == null) return null;
    try {
      return UserModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
    } on FormatException {
      return null;
    }
  }

  /// A 2xx without a token is not a session: model defaults would otherwise
  /// turn an empty `{}` body into a signed-in empty user. Nothing is stored
  /// unless the check passes.
  Future<Result<UserModel>> _persistSession(
    Result<AuthResponseModel> response,
  ) async {
    final AuthResponseModel auth;
    switch (response) {
      case Failure():
        return response.cast<UserModel>();
      case Success(:final data):
        auth = data;
    }
    return guard(() async {
      if (auth.token.isEmpty) {
        return const Result.error('Invalid response from server.');
      }
      await _secureStorage.write(auth.token, SecureKey.accessToken);
      final refresh = auth.refreshToken;
      if (refresh != null && refresh.isNotEmpty) {
        await _secureStorage.write(refresh, SecureKey.refreshToken);
      }
      await _sp.write(jsonEncode(auth.user.toJson()), StorageKey.user);
      return Result.success(auth.user);
    }, fallback: 'Could not save your session. Please try again.');
  }
}
