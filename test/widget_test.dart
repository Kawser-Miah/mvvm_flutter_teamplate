import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/app.dart';
import 'package:guard_well/features/quote/viewmodels/quote_viewmodel.dart';
import 'package:guard_well/model/quote/quote_model.dart';

class MockQuoteViewModel extends AsyncNotifier<List<QuoteModel>>
    implements QuoteViewModel {
  @override
  Future<List<QuoteModel>> build() async {
    return const [];
  }

  @override
  Future<void> refreshQuotes() async {}
}

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          quoteViewModelProvider.overrideWith(MockQuoteViewModel.new),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(App), findsOneWidget);
  });
}
