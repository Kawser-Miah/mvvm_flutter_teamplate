import 'package:guard_well/core/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guard_well/core/utils/app_texts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Primary button colors
final _primaryDisabledColor = AppColors.black.shade300;
final _primaryTextColor = AppColors.white;
final _primaryIconColor = AppColors.white;
final _primaryLoaderColor = AppColors.black[50]!;

// Primary button gradient (linear-gradient(89.58deg, #048150 5.15%, #0D553D 33.6%))
const _primaryGradient = LinearGradient(
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
  colors: [Color(0xFF048150), Color(0xFF0D553D)],
  stops: [0.0515, 0.336],
);

// Secondary button colors
const _secondaryColor = Color(0xFF3D4759);
const _secondaryBorderColor = AppColors.white;
const _secondaryTextColor = AppColors.white;
const _secondaryIconColor = AppColors.white;
const _secondaryLoaderColor = AppColors.white;

// Sizing defaults — ScreenUtil applied directly
double get _defaultHeight => 50.h;
double get _defaultWidth => double.infinity;
double get _defaultPadding => 40.w;
double get _defaultRadius => 999.r; // fully rounded / pill shape
double get _defaultFontSize => 16.sp;
double get _defaultIconSize => 24.r;
double get _iconTextSpacing => 8.w;

// Loading
const _loaderStrokeWidth = 4.0;
double get _loaderPadding => 8.r;
const _animationDuration = Duration(milliseconds: 100);

// Typography
final _textStyle = AppTexts.tlgm;

// ──────────────────────────────────────────────

class CustomButton extends StatefulWidget {
  final String text;
  final Function()? onTap;
  final bool isSecondary;
  final bool isDisabled;
  final double? height;
  final double? width;
  final bool isLoading;
  final String? leading;
  final String? trailing;
  final double? padding;
  final double? radius;
  final double? fontSize;
  final double? iconSize;
  final Color? textColor;
  final Color? borderColor;
  final Color? iconColor;
  final Color? backgroundColor;
  final Gradient? gradient;

  const CustomButton({
    super.key,
    required this.text,
    this.onTap,
    this.leading,
    this.trailing,
    this.padding,
    this.radius,
    this.isSecondary = false,
    this.isLoading = false,
    this.isDisabled = false,
    this.fontSize,
    this.iconSize,
    this.height,
    this.width,
    this.textColor,
    this.borderColor,
    this.iconColor,
    this.backgroundColor,
    this.gradient,
  });

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor =
        widget.borderColor ?? (widget.isSecondary ? _secondaryBorderColor : null);
    final effectiveTextColor =
        widget.textColor ?? (widget.isSecondary ? _secondaryTextColor : _primaryTextColor);
    final effectiveIconColor =
        widget.iconColor ?? (widget.isSecondary ? _secondaryIconColor : _primaryIconColor);

    final double effectiveHeight = widget.height ?? _defaultHeight;
    final double effectiveWidth = widget.width ?? _defaultWidth;
    final double effectivePadding = widget.padding ?? _defaultPadding;
    final double effectiveRadius = widget.radius ?? _defaultRadius;
    final double effectiveFontSize = widget.fontSize ?? _defaultFontSize;
    final double effectiveIconSize = widget.iconSize ?? _defaultIconSize;

    // Explicit backgroundColor (or gradient) always takes precedence over
    // the default primary/secondary/disabled styling.
    final bool hasCustomBackground =
        widget.backgroundColor != null || widget.gradient != null;

    final bool usePrimaryGradient = !hasCustomBackground &&
        !widget.isSecondary &&
        !widget.isDisabled;

    final Color? effectiveColor = widget.gradient != null
        ? null
        : widget.backgroundColor ??
        (widget.isSecondary
            ? _secondaryColor
            : widget.isDisabled
            ? _primaryDisabledColor
            : (usePrimaryGradient ? null : null));

    final Gradient? effectiveGradient =
        widget.gradient ?? (usePrimaryGradient ? _primaryGradient : null);

    return InkWell(
      borderRadius: BorderRadius.circular(effectiveRadius),
      onTap: widget.isLoading ? null : widget.onTap,
      child: AnimatedContainer(
        duration: _animationDuration,
        height: effectiveHeight,
        width: effectiveWidth,
        padding: EdgeInsets.symmetric(horizontal: effectivePadding),
        decoration: BoxDecoration(
          color: effectiveColor,
          gradient: effectiveGradient,
          borderRadius: BorderRadius.circular(effectiveRadius),
          border: effectiveBorderColor != null
              ? Border.all(color: effectiveBorderColor, width: 1)
              : null,
        ),
        child: widget.isLoading
            ? FittedBox(
          fit: BoxFit.scaleDown,
          child: Padding(
            padding: EdgeInsets.all(_loaderPadding),
            child: CircularProgressIndicator(
              color: widget.isSecondary ? _secondaryLoaderColor : _primaryLoaderColor,
              strokeWidth: _loaderStrokeWidth,
            ),
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          spacing: _iconTextSpacing,
          children: [
            if (widget.leading != null)
              SvgPicture.asset(
                widget.leading!,
                height: effectiveIconSize,
                width: effectiveIconSize,
                colorFilter:
                    ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
              ),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  widget.text,
                  maxLines: 1,
                  style: _textStyle.copyWith(
                    fontSize: effectiveFontSize,
                    color: effectiveTextColor,
                  ),
                ),
              ),
            ),
            if (widget.trailing != null)
              SvgPicture.asset(
                widget.trailing!,
                height: effectiveIconSize,
                width: effectiveIconSize,
                colorFilter:
                    ColorFilter.mode(effectiveIconColor, BlendMode.srcIn),
              ),
          ],
        ),
      ),
    );
  }
}