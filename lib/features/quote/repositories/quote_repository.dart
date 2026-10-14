import '../../../model/quote/quote_model.dart';
import '../services/quote_api_service.dart';

class QuoteRepository {
  final QuoteApiService _apiService;

  QuoteRepository(this._apiService);

  Future<List<QuoteModel>> getQuotes() {
    return _apiService.getQuotes();
  }
}
