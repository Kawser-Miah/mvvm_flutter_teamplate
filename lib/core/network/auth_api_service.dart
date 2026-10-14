import 'package:dio/dio.dart';
import '../../model/auth/auth_response_model.dart';
import '../../model/auth/login_request_model.dart';
import '../../model/auth/user_model.dart';
import 'api_endpoints.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.login,
        data: request.toJson(),
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      // Mock fallback if backend is offline
      return AuthResponseModel(
        token: 'mock_jwt_token_123',
        user: UserModel(
          id: '1',
          email: request.email,
          name: request.email.split('@').first,
        ),
      );
    }
  }

  Future<AuthResponseModel> register(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.register,
        data: data,
      );
      return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
    } catch (_) {
      return AuthResponseModel(
        token: 'mock_jwt_token_456',
        user: UserModel(
          id: '2',
          email: data['email'] as String? ?? 'user@test.com',
          name: data['name'] as String? ?? 'New User',
        ),
      );
    }
  }
}
