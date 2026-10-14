import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';

abstract class AuthRepository {
  Future<AuthResponseModel> login(LoginRequestModel request);
  Future<AuthResponseModel> register(Map<String, dynamic> data);
}
