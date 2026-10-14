import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/network/dio_client.dart';
import '../data_sources/quote_remote_data_source.dart';
import '../repositories/quote_repository.dart';

final quoteRemoteDataSourceProvider = Provider<QuoteRemoteDataSource>((ref) {
  return QuoteRemoteDataSource(ref.watch(dioClientProvider).dio);
});

final quoteRepositoryProvider = Provider<QuoteRepository>((ref) {
  return QuoteRepository(ref.watch(quoteRemoteDataSourceProvider));
});
