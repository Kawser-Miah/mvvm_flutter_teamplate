import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/dio_client.dart';
import '../repositories/quote_repository.dart';
import '../services/quote_api_service.dart';

final quoteApiServiceProvider = Provider<QuoteApiService>((ref) {
  final dioClient = ref.read(dioClientProvider);
  return QuoteApiService(dioClient.dio);
});

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  final apiService = ref.read(quoteApiServiceProvider);
  return QuoteRepository(apiService);
});
