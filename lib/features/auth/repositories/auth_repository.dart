import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';
import '../services/auth_api_service.dart';

class AuthRepository {
  final AuthApiService _apiService;

  AuthRepository(this._apiService);

  Future<AuthResponseModel> login(LoginRequestModel request) {
    return _apiService.login(request);
  }

  Future<AuthResponseModel> register(Map<String, dynamic> data) {
    return _apiService.register(data);
  }
}
