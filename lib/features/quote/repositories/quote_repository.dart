import '../../../core/errors/result.dart';
import '../../../model/quote/quote_model.dart';
import '../data_sources/quote_remote_data_source.dart';

class QuoteRepository {
  final QuoteRemoteDataSource _remoteDataSource;

  QuoteRepository(this._remoteDataSource);

  Future<Result<List<QuoteModel>>> getQuotes() {
    return _remoteDataSource.getQuotes();
  }
}
