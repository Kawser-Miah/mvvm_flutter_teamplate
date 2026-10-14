import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../core/errors/result.dart';
import '../../../core/services/network/api_endpoints.dart';
import '../../../core/services/network/result_call_adapter.dart';
import '../../../model/quote/quote_model.dart';

part 'quote_remote_data_source.g.dart';

@RestApi(callAdapter: ResultCallAdapter)
abstract class QuoteRemoteDataSource {
  factory QuoteRemoteDataSource(Dio dio, {String? baseUrl}) =
      _QuoteRemoteDataSource;

  @GET(ApiEndpoints.quotes)
  Future<Result<List<QuoteModel>>> getQuotes();
}
