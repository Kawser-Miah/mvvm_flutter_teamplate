import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_texts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES
// ──────────────────────────────────────────────
double get _flagWidth => 24.w;
double get _flagHeight => 18.h;
double get _flagRadius => 3.r;
double get _chevronSize => 18.r;
const _chevronColor = AppColors.black;
final _textStyle = AppTexts.txsr;
double get _itemSpacing => 6.w;
// ──────────────────────────────────────────────

class CountryCodeSelector extends StatelessWidget {
  final String dialCode; // e.g. "+880"
  final String? flagAsset; // pass an svg/png path if you have flag assets
  final VoidCallback? onTap;

  const CountryCodeSelector({
    super.key,
    required this.dialCode,
    this.flagAsset,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildFlag(),
          SizedBox(width: _itemSpacing),
          Icon(Icons.keyboard_arrow_down, size: _chevronSize, color: _chevronColor),
          SizedBox(width: _itemSpacing + 2.w),
          Text(dialCode, style: _textStyle),
        ],
      ),
    );
  }

  Widget _buildFlag() {
    if (flagAsset != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(_flagRadius),
        child: Image.asset(
          flagAsset!,
          width: _flagWidth,
          height: _flagHeight,
          fit: BoxFit.cover,
        ),
      );
    }
    // Fallback placeholder flag (Bangladesh) if no asset is wired up yet
    return Container(
      width: _flagWidth,
      height: _flagHeight,
      decoration: BoxDecoration(
        color: const Color(0xFF006A4E),
        borderRadius: BorderRadius.circular(_flagRadius),
      ),
      alignment: Alignment.center,
      child: Container(
        width: 9.r,
        height: 9.r,
        decoration: const BoxDecoration(
          color: Color(0xFFF42A41),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}