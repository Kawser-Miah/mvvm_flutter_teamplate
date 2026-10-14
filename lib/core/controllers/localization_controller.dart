import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/language_model.dart';
import '../utils/app_constants.dart';
import 'theme_controller.dart';

class LocalizationState {
  final Locale locale;
  final bool isLtr;
  final List<LanguageModel> languages;
  final int selectedIndex;

  LocalizationState({
    required this.locale,
    required this.isLtr,
    required this.languages,
    required this.selectedIndex,
  });

  LocalizationState copyWith({
    Locale? locale,
    bool? isLtr,
    List<LanguageModel>? languages,
    int? selectedIndex,
  }) {
    return LocalizationState(
      locale: locale ?? this.locale,
      isLtr: isLtr ?? this.isLtr,
      languages: languages ?? this.languages,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

final localizationProvider =
    NotifierProvider<LocalizationController, LocalizationState>(LocalizationController.new);

class LocalizationController extends Notifier<LocalizationState> {
  @override
  LocalizationState build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final langCode = prefs.getString(AppConstants.LANGUAGE_CODE) ??
        AppConstants.languages[0].languageCode;
    final countryCode = prefs.getString(AppConstants.COUNTRY_CODE) ??
        AppConstants.languages[0].countryCode;

    final loc = Locale(langCode, countryCode);
    final isLtr = langCode != 'ar';

    int selectedIdx = 0;
    for (int index = 0; index < AppConstants.languages.length; index++) {
      if (AppConstants.languages[index].languageCode == langCode) {
        selectedIdx = index;
        break;
      }
    }

    return LocalizationState(
      locale: loc,
      isLtr: isLtr,
      languages: List.from(AppConstants.languages),
      selectedIndex: selectedIdx,
    );
  }

  Locale get locale => state.locale;
  bool get isLtr => state.isLtr;
  List<LanguageModel> get languages => state.languages;
  int get selectedIndex => state.selectedIndex;

  void setLanguage(Locale locale) {
    final isLtr = locale.languageCode != 'ar';
    saveLanguage(locale);
    state = state.copyWith(
      locale: locale,
      isLtr: isLtr,
    );
  }

  void saveLanguage(Locale locale) {
    final prefs = ref.read(sharedPreferencesProvider);
    prefs.setString(
      AppConstants.LANGUAGE_CODE,
      locale.languageCode,
    );
    prefs.setString(
      AppConstants.COUNTRY_CODE,
      locale.countryCode ?? "",
    );
  }

  void setSelectIndex(int index) {
    state = state.copyWith(selectedIndex: index);
  }

  void searchLanguage(String query) {
    if (query.isEmpty) {
      state = state.copyWith(
        languages: List.from(AppConstants.languages),
      );
    } else {
      final filtered = AppConstants.languages
          .where((l) => l.languageName.toLowerCase().contains(query.toLowerCase()))
          .toList();
      state = state.copyWith(
        selectedIndex: -1,
        languages: filtered,
      );
    }
  }
}
