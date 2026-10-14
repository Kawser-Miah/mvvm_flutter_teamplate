import 'package:dio/dio.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../model/quote/quote_model.dart';

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
      return [];
    } catch (_) {
      // Mock data fallback for demonstration if API endpoint is not active
      return const [
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
      ];
    }
  }
}
