import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/secure_storage_service/secure_storage_service.dart';
import 'core/services/sp_service/sp_service.dart';
import 'features/auth/providers/auth_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Created once; every read after this is synchronous via SpService.
  final prefs = await SharedPreferences.getInstance();

  // Restore the session before the first frame so the router can pick its
  // initialLocation once, without a redirect.
  const secureStorage = FlutterSecureStorage();
  final token =
      await SecureStorageServiceImpl(secureStorage).read(SecureKey.accessToken);

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        flutterSecureStorageProvider.overrideWithValue(secureStorage),
        signedInAtLaunchProvider
            .overrideWithValue(token != null && token.isNotEmpty),
      ],
      child: const App(),
    ),
  );
}
