import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_texts.dart';
import 'package:guard_well/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _dialogBackgroundColor = AppColors.scaffoldBg;
const _titleColor = AppColors.textPrimary;
const _highlightColor = AppColors.appPrimaryColor;

// Sizing
double get _dialogRadius => 20.r;
double get _dialogHorizontalInset => 24.w;
double get _contentHorizontalPadding => 20.w;
double get _contentVerticalPadding => 24.h;
double get _titleHighlightSpacing => 6.h;
double get _buttonsTopSpacing => 24.h;
double get _buttonSpacing => 12.w;

// Title typography
double get _titleFontSize => 18.sp;

// Highlight typography
double get _highlightFontSize => 20.sp;

// ──────────────────────────────────────────────

class OverlayConfirmation extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? highlight;
  final String? buttonTextLeft;
  final String? buttonTextRight;
  final void Function()? buttonCallBackLeft;
  final void Function()? buttonCallBackRight;
  final bool leftButtonIsSecondary;
  final Color? leftButtonBackgroundColor;
  final Color? leftButtonBorderColor;
  final Color? leftButtonTextColor;
  final Color? rightButtonBackgroundColor;
  final Color? rightButtonBorderColor;
  final Color? rightButtonTextColor;

  const OverlayConfirmation({
    super.key,
    required this.title,
    this.subtitle,
    this.highlight,
    this.buttonTextLeft,
    this.buttonTextRight,
    this.buttonCallBackLeft,
    this.buttonCallBackRight,
    this.leftButtonIsSecondary = true,
    this.leftButtonBackgroundColor,
    this.leftButtonBorderColor,
    this.leftButtonTextColor,
    this.rightButtonBackgroundColor,
    this.rightButtonBorderColor,
    this.rightButtonTextColor,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: _dialogHorizontalInset),
      contentPadding: EdgeInsets.symmetric(
        horizontal: _contentHorizontalPadding,
        vertical: _contentVerticalPadding,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_dialogRadius),
        side: BorderSide(
          color: AppColors.white.withValues(alpha: 0.15),
          width: 1.w,
        ),
      ),
      backgroundColor: _dialogBackgroundColor,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTexts.txsb.copyWith(
              color: _titleColor,
              fontSize: _titleFontSize,
              height: 1.3,
            ),
          ),
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTexts.tsmr.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                height: 1.4,
              ),
            ),
          ],
          if (highlight != null) ...[
            SizedBox(height: _titleHighlightSpacing),
            Text(
              highlight!,
              textAlign: TextAlign.center,
              style: AppTexts.dxsb.copyWith(
                color: _highlightColor,
                fontSize: _highlightFontSize,
              ),
            ),
          ],
          SizedBox(height: _buttonsTopSpacing),
          Row(
            children: [
              if (buttonTextLeft != null)
                Expanded(
                  child: CustomButton(
                    text: buttonTextLeft!,
                    isSecondary: leftButtonIsSecondary,
                    backgroundColor: leftButtonBackgroundColor,
                    borderColor: leftButtonBorderColor,
                    textColor: leftButtonTextColor,
                    onTap: buttonCallBackLeft,
                    height: 46.h,
                    radius: 14.r,
                  ),
                ),
              if (buttonTextLeft != null && buttonTextRight != null)
                SizedBox(width: _buttonSpacing),
              if (buttonTextRight != null)
                Expanded(
                  child: CustomButton(
                    text: buttonTextRight!,
                    isSecondary: !leftButtonIsSecondary,
                    backgroundColor: rightButtonBackgroundColor,
                    borderColor: rightButtonBorderColor,
                    textColor: rightButtonTextColor,
                    onTap: buttonCallBackRight,
                    height: 46.h,
                    radius: 14.r,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
