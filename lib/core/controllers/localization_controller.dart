import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/common/language_model.dart';
import '../constants/app_constants.dart';
import '../services/sp_service/sp_service.dart';

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
    final sp = ref.watch(spServiceProvider);
    final langCode = sp.read<String>(StorageKey.languageCode) ??
        AppConstants.languages[0].languageCode;
    final countryCode = sp.read<String>(StorageKey.countryCode) ??
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

  Future<void> setLanguage(Locale locale) async {
    final isLtr = locale.languageCode != 'ar';
    state = state.copyWith(
      locale: locale,
      isLtr: isLtr,
    );
    await saveLanguage(locale);
  }

  Future<void> saveLanguage(Locale locale) async {
    final sp = ref.read(spServiceProvider);
    await sp.write(locale.languageCode, StorageKey.languageCode);
    await sp.write(locale.countryCode ?? '', StorageKey.countryCode);
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
