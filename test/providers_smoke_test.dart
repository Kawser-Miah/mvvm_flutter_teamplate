import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/core/controllers/localization_controller.dart';
import 'package:guard_well/core/controllers/theme_controller.dart';
import 'package:guard_well/core/errors/result.dart';
import 'package:guard_well/core/router/app_router.dart';
import 'package:guard_well/core/services/network/dio_client.dart';
import 'package:guard_well/core/services/secure_storage_service/secure_storage_service.dart';
import 'package:guard_well/core/services/sp_service/sp_service.dart';
import 'package:guard_well/features/auth/providers/auth_providers.dart';
import 'package:guard_well/features/auth/viewmodels/login_viewmodel.dart';
import 'package:guard_well/features/auth/viewmodels/logout_viewmodel.dart';
import 'package:guard_well/features/auth/viewmodels/register_viewmodel.dart';
import 'package:guard_well/features/quote/data_sources/quote_remote_data_source.dart';
import 'package:guard_well/features/quote/providers/quote_providers.dart';
import 'package:guard_well/features/quote/viewmodels/quote_viewmodel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockQuoteRemoteDataSource extends Mock implements QuoteRemoteDataSource {}

/// Builds every top-level provider so a broken dependency fails here instead
/// of on a screen at runtime.
void main() {
  late ProviderContainer container;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    FlutterSecureStorage.setMockInitialValues({});
    final quotes = MockQuoteRemoteDataSource();
    when(quotes.getQuotes).thenAnswer((_) async => const Result.success([]));

    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider
            .overrideWithValue(await SharedPreferences.getInstance()),
        // Only the network edge is faked; repository + view-model are real.
        quoteRemoteDataSourceProvider.overrideWithValue(quotes),
      ],
    );
  });

  tearDown(() => container.dispose());

  test('services', () {
    expect(container.read(spServiceProvider), isA<SpService>());
    expect(
      container.read(secureStorageServiceProvider),
      isA<SecureStorageService>(),
    );
    expect(container.read(dioClientProvider).dio.interceptors, isNotEmpty);
  });

  test('router starts on login when signed out', () {
    final router = container.read(appRouterProvider);
    expect(
      router.routeInformationProvider.value.uri.path,
      PAGES.login.screenPath,
    );
    expect(AppRouter.router, same(router));
  });

  test('repositories and data sources', () {
    container
      ..read(authRemoteDataSourceProvider)
      ..read(authRepositoryProvider)
      ..read(quoteRepositoryProvider);
  });

  test('controllers and view-models', () async {
    expect(container.read(themeProvider), isTrue);
    expect(container.read(localizationProvider).locale.languageCode, 'en');
    expect(await container.read(loginViewModelProvider.future), isNull);
    expect(await container.read(registerViewModelProvider.future), isNull);
    await container.read(logoutViewModelProvider.future);
    expect(await container.read(quoteViewModelProvider.future), isEmpty);
  });
}
