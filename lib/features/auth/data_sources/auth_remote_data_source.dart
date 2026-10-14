import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  @POST(ApiEndpoints.login)
  Future<AuthResponseModel> login(@Body() LoginRequestModel request);

  @POST(ApiEndpoints.register)
  Future<AuthResponseModel> register(@Body() Map<String, dynamic> data);
}
