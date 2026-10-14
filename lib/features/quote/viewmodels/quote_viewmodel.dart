import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../model/quote/quote_model.dart';
import '../providers/quote_providers.dart';

final quoteViewModelProvider =
    AsyncNotifierProvider<QuoteViewModel, List<QuoteModel>>(
  QuoteViewModel.new,
);

class QuoteViewModel extends AsyncNotifier<List<QuoteModel>> {
  @override
  Future<List<QuoteModel>> build() async {
    final repository = ref.read(quoteRepositoryProvider);
    return (await repository.getQuotes()).getOrThrow();
  }

  Future<void> refreshQuotes() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final repository = ref.read(quoteRepositoryProvider);
      return (await repository.getQuotes()).getOrThrow();
    });
  }
}
