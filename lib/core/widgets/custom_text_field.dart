import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/utils/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:guard_well/core/utils/app_texts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _backgroundColor = AppColors.containerBackground;
const _cursorColor = AppColors.black;
const _errorColor = AppColors.red;

// Border
double get _defaultRadius => 16.r;

// Sizing defaults
double get _defaultHeight => 54.h;
double get _horizontalPadding => 12.w;
double get _multilineVerticalPadding => 14.h;
double get _iconSize => 20.r;
double get _itemSpacing => 12.w;

// Icon colors
final _iconFocusedColor = AppColors.black.shade100;
final _iconUnfocusedColor = AppColors.black.shade100;
final _toggleIconUnfocusedColor = AppColors.gray.shade100;

// Title
double get _titleBottomPadding => 8.h;
final _titleStyle = AppTexts.tmdr;

// Input text
final _inputStyle = AppTexts.txsr;
final _hintColor = AppColors.textPrimary;

// Error text
double get _errorHorizontalPadding => 24.w;
double get _errorFontSize => 12.sp;
const _errorFontWeight = 400.0;

// ──────────────────────────────────────────────

class CustomTextField extends StatefulWidget {
  final String? title;
  final bool isRequired;
  final String? hintText;
  final String? errorText;
  final String? leading;
  final String? trailing;
  final TextInputType? textInputType;
  final bool isDisabled;
  final double? radius;
  final double? height;
  final double? width;
  final TextEditingController? controller;
  final bool isPassword;
  final int lines;
  final void Function()? onTap;
  final Widget? leadingWidget;
  final Color? backgroundColor;
  final Color? borderColor;
  final bool? isObscured;
  final VoidCallback? onTogglePassword;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;
  final Widget? trailingWidget;

  const CustomTextField({
    super.key,
    this.title,
    this.isRequired = false,
    this.hintText,
    this.leading,
    this.trailing,
    this.isPassword = false,
    this.isDisabled = false,
    this.radius,
    this.lines = 1,
    this.textInputType,
    this.controller,
    this.onTap,
    this.errorText,
    this.height,
    this.width,
    this.leadingWidget,
    this.trailingWidget,
    this.backgroundColor,
    this.borderColor,
    this.isObscured,
    this.onTogglePassword,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isObscured = false;
  bool isFocused = false;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    isObscured = widget.isPassword;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() => isFocused = true);
      } else {
        setState(() => isFocused = false);
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.radius ?? _defaultRadius;
    final effectiveHeight = widget.height ?? _defaultHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(bottom: _titleBottomPadding),
            child: Text.rich(
              TextSpan(
                text: widget.title!,
                style: _titleStyle,
                children: [
                  if (widget.isRequired)
                    TextSpan(text: ' *', style: _titleStyle.copyWith(color: _errorColor)),
                ],
              ),
            ),
          ),
        GestureDetector(
          onTap: () {
            if (widget.onTap != null) {
              widget.onTap!();
            } else if (!widget.isDisabled) {
              focusNode.requestFocus();
            }
          },
          child: Container(
            height: widget.lines == 1 ? effectiveHeight : null,
            width: widget.width,
            padding: EdgeInsets.symmetric(
              horizontal: _horizontalPadding,
              vertical: widget.lines == 1 ? 0 : _multilineVerticalPadding,
            ),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? _backgroundColor,
              borderRadius: BorderRadius.circular(effectiveRadius),
              // border: isFocused
              //     ? Border.all(color: _focusBorderColor, width: _focusBorderWidth)
              //     : Border.all(
              //         color: widget.borderColor ?? _defaultBorderColor[_defaultBorderShade]!,
              //         width: _defaultBorderWidth,
              //       ),
            ),
            child: Row(
              spacing: _itemSpacing,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (widget.leadingWidget != null)
                  widget.leadingWidget!
                else if (widget.leading != null)
                  SvgPicture.asset(
                    widget.leading!,
                    height: _iconSize,
                    width: _iconSize,
                    colorFilter: ColorFilter.mode(
                      isFocused ? _iconFocusedColor : _iconUnfocusedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                Expanded(
                  child: TextField(
                    focusNode: focusNode,
                    controller: widget.controller,
                    onChanged: widget.onChanged,
                    maxLines: widget.lines,
                    cursorColor: _cursorColor,
                    keyboardType: widget.textInputType,
                    textInputAction: widget.textInputAction,
                    onSubmitted: widget.onSubmitted,
                    obscureText: widget.isPassword ? (widget.isObscured ?? isObscured) : false,
                    enabled: !widget.isDisabled && widget.onTap == null,
                    onTapOutside: (event) {
                      setState(() {
                        isFocused = false;
                        focusNode.unfocus();
                      });
                    },
                    style: _inputStyle,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      hintText: widget.hintText,
                      hintStyle: _inputStyle.copyWith(color: _hintColor),
                    ),
                  ),
                ),
                if (widget.trailingWidget != null)
                  widget.trailingWidget!
                else if (widget.trailing != null)
                  SvgPicture.asset(
                    widget.trailing!,
                    height: _iconSize,
                    width: _iconSize,
                    colorFilter: ColorFilter.mode(
                      isFocused ? _iconFocusedColor : _iconUnfocusedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () {
                      if (widget.onTogglePassword != null) {
                        widget.onTogglePassword!();
                      } else {
                        setState(() => isObscured = !isObscured);
                      }
                    },
                    behavior: HitTestBehavior.translucent,
                    child: SvgPicture.asset(
                      (widget.isObscured ?? isObscured) ? AppIcons.eyeOff : AppIcons.eye,
                      width: _iconSize,
                      colorFilter: ColorFilter.mode(
                        isFocused ? _iconFocusedColor : _toggleIconUnfocusedColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        if (widget.errorText != null)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: _errorHorizontalPadding),
            child: Text(
              widget.errorText!,
              style: TextStyle(
                fontVariations: [const FontVariation("wght", _errorFontWeight)],
                fontSize: _errorFontSize,
                color: _errorColor,
              ),
            ),
          ),
      ],
    );
  }
}
