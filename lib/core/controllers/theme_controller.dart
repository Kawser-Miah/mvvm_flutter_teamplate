import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/sp_service/sp_service.dart';

final themeProvider = NotifierProvider<ThemeController, bool>(ThemeController.new);

class ThemeController extends Notifier<bool> {
  @override
  bool build() {
    return ref.watch(spServiceProvider).read<bool>(StorageKey.themeIsDark) ??
        true;
  }

  bool get darkTheme => state;

  Future<void> toggleTheme() async {
    state = !state;
    await ref.read(spServiceProvider).write(state, StorageKey.themeIsDark);
  }

  void changeTheme(Color lightColor, Color darkColor) {}
}
