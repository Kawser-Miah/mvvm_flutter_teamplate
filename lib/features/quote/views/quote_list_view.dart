import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/router/pages.dart';
import '../../../core/widgets/app_app_bar.dart';
import '../../../core/widgets/app_loader.dart';
import '../../auth/viewmodels/logout_viewmodel.dart';
import '../viewmodels/quote_viewmodel.dart';
import '../widgets/quote_card.dart';

class QuoteListView extends ConsumerWidget {
  const QuoteListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quotesState = ref.watch(quoteViewModelProvider);

    ref.listen(logoutViewModelProvider, (previous, next) {
      if (previous?.isLoading != true) return;
      next.whenOrNull(
        data: (_) => context.go(PAGES.login.screenPath),
        error: (error, _) => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        ),
      );
    });

    return Scaffold(
      appBar: AppAppBar(
        title: 'Quotes',
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Design System',
            onPressed: () => context.push(PAGES.designSystem.screenPath),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign out',
            onPressed: () =>
                ref.read(logoutViewModelProvider.notifier).logout(),
          ),
        ],
      ),
      body: SafeArea(
        child: quotesState.when(
          data: (quotes) {
            if (quotes.isEmpty) {
              return const Center(child: Text('No quotes found.'));
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(quoteViewModelProvider.notifier).refreshQuotes(),
              child: ListView.builder(
                itemCount: quotes.length,
                itemBuilder: (context, index) {
                  return QuoteCard(quote: quotes[index]);
                },
              ),
            );
          },
          loading: () => const AppLoader(),
          error: (error, _) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(error.toString()),
                ElevatedButton(
                  onPressed: () =>
                      ref.read(quoteViewModelProvider.notifier).refreshQuotes(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
