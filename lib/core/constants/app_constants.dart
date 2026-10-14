import '../../model/common/language_model.dart';

abstract final class AppConstants {
  static const String appName = 'Guard Well';
  static const double designWidth = 375;
  static const double designHeight = 812;

  static const List<LanguageModel> languages = [
    LanguageModel(
      languageName: 'English',
      countryCode: 'US',
      languageCode: 'en',
    ),
    LanguageModel(languageName: 'عربى', countryCode: 'SA', languageCode: 'ar'),
    LanguageModel(
      languageName: 'Spanish',
      countryCode: 'ES',
      languageCode: 'es',
    ),
  ];
}
