import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color appPrimaryColor = Color(0xFF2CC36A);

  static const Color appSecondaryColor = Color(0xFFF8B941);
  static const Color greenPrimary = Color(0xFF5BB458);

  static const Color lightGreen = Color(0xFFD9FFE1);
  static const Color infoBlue = Color(0xFF33BEE4);
  static const Color lightBlue = Color(0xFFBAE1FE);
  static const Color lightIndigo = Color(0xFFACB7FF);
  static const Color royalBlue = Color(0xFF3367CD);
  static const Color yellow = Color(0xFFFFBE42);
  static const Color transparent = Colors.transparent;
  static const Color scaffoldBackgroundColor = Color(0xFF010619);
  static const Color containerBackground = Color(0x1AFFFFFF);

  static const Color scaffoldBg = Color(0xFF010619);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB2FFFFFF);
  static const Color textInput = Color(0xFF9CA3AF);
  static const Color surfaceMuted = Color(0xFFF3F4F6);

  /// Hairline around the white detail cards.
  static const Color cardBorder = Color(0xFFF9FAFB);

  /// Brand gradient — earnings card, client-needs banner, finance balance.
  static const Color gradientStart = Color(0xFF2CC36A);
  static const Color gradientEnd = Color(0xFFBE8E32);

  /// Soft elevation shared by every white card on the dashboard.
  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 2)),
  ];

  // Green

  // Custom UI Fill & Border Colors
  static const Color iceBlue = Color(0xFFEEF3F8);
  static const Color dashedBorderColor = Color(0xFFC5D3E0);
  static const Color pickerBorderColor = Color(0xFFC7D5E0);
  static const Color slateNavy = Color(0xFF1E293B);
  static const Color darkSlate = Color(0xFF2C384E);
  static const Color lavenderTint = Color(0xFFDEE2FC);
  static const Color lightFieldBg = Color(0xFFF9FAFB);
  static const Color onboardingDarkNavy = Color(0xFF0F172B);
  static const Color lightPurple = Color(0xFFB8BAFF);

  // Black Material Color
  static const MaterialColor black = MaterialColor(0xFF000000, {
    25: Color(0x1A000000),
    50: Color(0xFFE6E6E6),
    100: Color(0xFF6B7280),
    200: Color(0xFF8A8A8A),
    300: Color(0xFF545454),
    400: Color(0xFF333333),
    500: Color(0xFF2B2A2A),
    600: Color(0xFF6B7280),
  });

  // Primary Blue Material Color (Shade Wise)
  static const MaterialColor primaryBlue = MaterialColor(0xFF5B5FEF, {
    25: Color(0xFFF5F8FF),
    50: Color(0xFFEEF2FF),
    100: Color(0x335B5FEF),
    200: Color(0xFF8A8A8A),
    300: Color(0xFF545454),
    400: Color(0xFF333333),
    500: Color(0xFF5B5FEF),
    600: Color(0xFF3367CD),
  });

  // Green Material Color (Shade Wise)
  static const MaterialColor green = MaterialColor(0xFF2CC36A, {
    25: Color(0xFFF5FFF4),
    50: Color(0xFFE8FAEA),
    100: Color(0xFFD9FFE1),
    200: Color(0xFF94E79D),
    300: Color(0xFF6ACD70),
    400: Color(0xFF4DD55D),
    500: Color(0xFF2CC36A),
    600: Color(0xFF158B26),
    700: Color(0xFF108F1F),
    800: Color(0xFF0D6F17),
    900: Color(0xFF0A5512),
  });

  // Gold Material Color
  static const MaterialColor gold = MaterialColor(0xFFD89E29, {
    25: Color(0xFFFFF7ED),
    50: Color(0xFFFFE6D5),
    100: Color(0xFFFED7AA),
    200: Color(0xFFFDBA74),
    300: Color(0xFFFB923C),
    400: Color(0xFFFB7316),
    500: Color(0xFFE85A00),
    600: Color(0xFFCC4210),
    700: Color(0xFFA34142),
    800: Color(0xFF7C2C12),
    900: Color(0xFF431407),
  });

  // Red Material Color
  static const MaterialColor red = MaterialColor(0xFFDC2626, {
    25: Color(0xFFFEF2F2),
    50: Color(0xFFFEE2E2),
    100: Color(0x33D89E29),
    200: Color(0xFFFCA5A5),
    300: Color(0xFFF87171),
    400: Color(0xFFEF4444),
    500: Color(0xFFDC2626),
    600: Color(0xFFB91C1C),
    700: Color(0xFF991B1B),
    800: Color(0xFF7F1D1D),
    900: Color(0xFF450A0A),
  });

  // Gray Material Color (Shade Wise)
  static const MaterialColor gray = MaterialColor(0xFF4B5563, {
    25: Color(0xFFFAFAFB),
    50: Color(0xFFF3F4F6),
    100: Color(0xFFE9E9E9), // Very Light Gray
    200: Color(0xFFDCDCDC), // Light Gray
    300: Color(0xFF9CA3AF),
    400: Color(0xFF6E7280),
    450: Color(0xFF545454), // Custom shade text secondary
    500: Color(0xFF4B5563),
    600: Color(0xFF374151),
    700: Color(0xFF1F2937),
    800: Color(0xFF111827),
    900: Color(0xFF030712),
  });
}
