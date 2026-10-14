import 'package:dio/dio.dart';
import '../../model/quote/quote_model.dart';
import 'api_endpoints.dart';

class QuoteApiService {
  final Dio _dio;

  QuoteApiService(this._dio);

  Future<List<QuoteModel>> getQuotes() async {
    try {
      final response = await _dio.get(ApiEndpoints.quotes);
      final data = response.data;
      if (data is List) {
        return data
            .map((item) => QuoteModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return _mockQuotes;
    } catch (_) {
      return _mockQuotes;
    }
  }

  static const List<QuoteModel> _mockQuotes = [
    QuoteModel(
      id: '1',
      author: 'Mahatma Gandhi',
      quote: 'Be the change that you wish to see in the world.',
    ),
    QuoteModel(
      id: '2',
      author: 'Steve Jobs',
      quote: 'The only way to do great work is to love what you do.',
    ),
    QuoteModel(
      id: '3',
      author: 'Albert Einstein',
      quote: 'In the middle of difficulty lies opportunity.',
    ),
  ];
}
