import 'package:flutter/material.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

/// AppTexts
/// ---------------------------------------------------------------------------
/// Naming Convention:
/// d = Display text (large headings, hero titles) -> "SF Pro Display"
/// t = Text (body text, labels, paragraphs)       -> "SF Pro Text"
///
/// The d/t split mirrors Apple's own optical sizing: Display is tighter and
/// meant for large type, Text is looser and stays legible at small sizes.
///
/// Size scale (largest → smallest):
/// 2xl, xl, lg, md, sm, xs
///
/// Weight suffix:
/// r = Regular (FontWeight.w400)
/// m = Medium  (FontWeight.w500)
/// s = SemiBold(FontWeight.w600)
/// b = Bold    (FontWeight.w700)
///
/// Example:
/// dxlb -> Display, Extra Large, Bold
/// tsmr -> Text, Small, Regular
///
/// Usage:
/// Text("Hello", style: AppTexts.tmdr);
///
/// Customization:
/// Use copyWith() to override only what you need without breaking the system.
/// Example:
/// AppTexts.tmdr.copyWith(color: Colors.red, fontSize: 15);
///
/// Note: only w400–w700 are bundled, and italics only for Display 400/500.
/// Asking for a weight/style that isn't bundled falls back to the nearest one.
/// ---------------------------------------------------------------------------
class AppTexts {
  static const String displayFamily = "SF Pro Display";
  static const String textFamily = "SF Pro Text";

  // =========================
  // Display
  // =========================

  // 2XL – 72
  static TextStyle d2xlr = _display(72.sp, 88, FontWeight.w400);
  static TextStyle d2xlm = _display(72.sp, 88, FontWeight.w500);
  static TextStyle d2xls = _display(72.sp, 88, FontWeight.w600);
  static TextStyle d2xlb = _display(72.sp, 88, FontWeight.w700);

  // XL – 60
  static TextStyle dxlr = _display(60.sp  , 72, FontWeight.w400);
  static TextStyle dxlm = _display(60.sp, 72, FontWeight.w500);
  static TextStyle dxls = _display(60.sp, 72, FontWeight.w600);
  static TextStyle dxlb = _display(60.sp, 72, FontWeight.w700);

  // LG – 48
  static TextStyle dlgr = _display(48.sp, 60, FontWeight.w400);
  static TextStyle dlgm = _display(48.sp, 60, FontWeight.w500);
  static TextStyle dlgs = _display(48.sp, 60, FontWeight.w600);
  static TextStyle dlgb = _display(48.sp, 60, FontWeight.w700);

  // MD – 36
  static TextStyle dmdr = _display(36.sp, 44, FontWeight.w400);
  static TextStyle dmdm = _display(36.sp, 44, FontWeight.w500);
  static TextStyle dmds = _display(36.sp, 44, FontWeight.w600);
  static TextStyle dmdb = _display(36.sp, 44, FontWeight.w700);

  // SM – 30
  static TextStyle dsmr = _display(32.sp, 36, FontWeight.w400);
  static TextStyle dsmm = _display(32.sp, 36, FontWeight.w500);
  static TextStyle dsms = _display(32.sp, 36, FontWeight.w600);
  static TextStyle dsmb = _display(32.sp, 36, FontWeight.w700);

  // XS – 24
  static TextStyle dxsr = _display(24.sp, 32, FontWeight.w400);
  static TextStyle dxsm = _display(24.sp, 32, FontWeight.w500);
  static TextStyle dxss = _display(24.sp, 32, FontWeight.w600);
  static TextStyle dxsb = _display(24.sp, 32, FontWeight.w700);

  // =========================
  // Text
  // =========================

  // XL – 20
  static TextStyle txlr = _text(20.sp, 30, FontWeight.w400);
  static TextStyle txlm = _text(20.sp, 30, FontWeight.w500);
  static TextStyle txls = _text(20.sp, 30, FontWeight.w600);
  static TextStyle txlb = _text(20.sp, 30, FontWeight.w700);

  // LG – 18
  static TextStyle tlgr = _text(18.sp, 24, FontWeight.w400);
  static TextStyle tlgm = _text(18.sp, 24, FontWeight.w500);
  static TextStyle tlgs = _text(18.sp, 24, FontWeight.w600);
  static TextStyle tlgb = _text(18.sp, 24, FontWeight.w700);

  // MD – 16
  static TextStyle tmdr = _text(16.sp, 16, FontWeight.w400);
  static TextStyle tmdm = _text(16.sp, 16, FontWeight.w500);
  static TextStyle tmds = _text(16.sp, 16, FontWeight.w600);
  static TextStyle tmdb = _text(16.sp, 16, FontWeight.w700);

  // SM – 14
  static TextStyle tsmr = _text(14.sp, 20, FontWeight.w400);
  static TextStyle tsmm = _text(14.sp, 20, FontWeight.w500);
  static TextStyle tsms = _text(14.sp, 20, FontWeight.w600);
  static TextStyle tsmb = _text(14.sp, 20, FontWeight.w700);

  // XS – 12
  static TextStyle txsr = _text(12.sp, 16, FontWeight.w400);
  static TextStyle txsm = _text(12.sp, 16, FontWeight.w500);
  static TextStyle txss = _text(12.sp, 16, FontWeight.w600);
  static TextStyle txsb = _text(12.sp, 16, FontWeight.w700);

  // XXS – 10
  static TextStyle txxsr = _text(10.sp, 14, FontWeight.w400);
  static TextStyle txxsm = _text(10.sp, 14, FontWeight.w500);
  static TextStyle txxss = _text(10.sp, 14, FontWeight.w600);
  static TextStyle txxsb = _text(10.sp, 14, FontWeight.w700);

  /// Display ramp — "SF Pro Display"
  static TextStyle _display(
    double fontSize,
    double lineHeight,
    FontWeight weight,
  ) => _base(displayFamily, fontSize, lineHeight, weight);

  /// Text ramp — "SF Pro Text"
  static TextStyle _text(
    double fontSize,
    double lineHeight,
    FontWeight weight,
  ) => _base(textFamily, fontSize, lineHeight, weight);

  /// Base text style generator
  ///
  /// [family] → Font family (Display or Text ramp)
  /// [fontSize] → Text size
  /// [lineHeight] → Desired line height in px (converted internally)
  /// [weight] → FontWeight (w400–w700)
  ///
  /// Centralizing this ensures:
  /// - Consistent font family
  /// - Consistent default color
  /// - Easy future changes (font, color, scaling)
  static TextStyle _base(
    String family,
    double fontSize,
    double lineHeight,
    FontWeight weight,
  ) {
    return TextStyle(
      fontFamily: family,
      fontSize: fontSize,
      height: lineHeight / fontSize,
      fontWeight: weight,
      color: AppColors.textPrimary,
    );
  }
}
