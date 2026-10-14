import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';
import '../data_sources/auth_remote_data_source.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Future<AuthResponseModel> login(LoginRequestModel request) {
    return _remoteDataSource.login(request);
  }

  @override
  Future<AuthResponseModel> register(Map<String, dynamic> data) {
    return _remoteDataSource.register(data);
  }
}
