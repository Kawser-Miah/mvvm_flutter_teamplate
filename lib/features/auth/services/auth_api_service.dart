import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';

class AuthApiService {
  final Dio _dio;

  AuthApiService(this._dio);

  Future<AuthResponseModel> login(LoginRequestModel request) async {
    final response = await _dio.post(
      ApiEndpoints.login,
      data: request.toJson(),
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<AuthResponseModel> register(Map<String, dynamic> data) async {
    final response = await _dio.post(
      ApiEndpoints.register,
      data: data,
    );
    return AuthResponseModel.fromJson(response.data as Map<String, dynamic>);
  }
}
