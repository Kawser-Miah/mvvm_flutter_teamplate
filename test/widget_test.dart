import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:guard_well/app.dart';
import 'package:guard_well/core/services/sp_service/sp_service.dart';
import 'package:guard_well/features/auth/views/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('boots to the login screen when signed out', (tester) async {
    SharedPreferences.setMockInitialValues({});
    // Without this the secure-storage platform channel hangs the test.
    FlutterSecureStorage.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });
}
