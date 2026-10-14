import 'package:flutter/material.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/utils/app_texts.dart';

ThemeData dark() => ThemeData(
  fontFamily: AppTexts.textFamily,
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.scaffoldBg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.appPrimaryColor,
    secondary: AppColors.appSecondaryColor,
    surface: AppColors.scaffoldBg,
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.appPrimaryColor,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: AppColors.scaffoldBg,
  ),
);
