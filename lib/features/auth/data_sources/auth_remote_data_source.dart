import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/errors/result.dart';
import '../../../core/services/network/api_endpoints.dart';
import '../../../core/services/network/result_call_adapter.dart';
import '../../../model/auth/auth_response_model.dart';
import '../../../model/auth/login_request_model.dart';

part 'auth_remote_data_source.g.dart';

@RestApi(callAdapter: ResultCallAdapter)
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  @POST(ApiEndpoints.login)
  Future<Result<AuthResponseModel>> login(@Body() LoginRequestModel request);

  @POST(ApiEndpoints.register)
  Future<Result<AuthResponseModel>> register(@Body() Map<String, dynamic> data);
}
