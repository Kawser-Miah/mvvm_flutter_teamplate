import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/app_constants.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize sharedPreferencesProvider in ProviderScope overrides');
});

final themeProvider = NotifierProvider<ThemeController, bool>(ThemeController.new);

class ThemeController extends Notifier<bool> {
  @override
  bool build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getBool(AppConstants.THEME) ?? true;
  }

  bool get darkTheme => state;

  void toggleTheme() {
    final prefs = ref.read(sharedPreferencesProvider);
    state = !state;
    prefs.setBool(AppConstants.THEME, state);
  }

  void changeTheme(Color lightColor, Color darkColor) {}
}