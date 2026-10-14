import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _activeColor = AppColors.black;
const _inactiveColor = AppColors.gray;
const _checkmarkColor = Colors.white;
const _inactiveBackgroundColor = Colors.transparent;

// Sizing
double get _defaultSize => 28.r;
const _checkmarkScale = 0.7;
const _borderWidth = 2.0;
double get _defaultRadius => 6.r;

// Animation
const _animationDuration = Duration(milliseconds: 200);
const _animationCurve = Curves.easeInOut;

// ──────────────────────────────────────────────

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final double? size;
  final BorderRadius? borderRadius;

  const CustomCheckBox({
    super.key,
    required this.value,
    required this.onChanged,
    this.activeColor = _activeColor,
    this.inactiveColor = _inactiveColor,
    this.size,
    this.borderRadius,
  });

  @override
  CustomCheckBoxState createState() => CustomCheckBoxState();
}

class CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    final effectiveSize = widget.size ?? _defaultSize;
    final effectiveRadius = widget.borderRadius ?? BorderRadius.all(Radius.circular(_defaultRadius));

    return GestureDetector(
      onTap: () => widget.onChanged(!widget.value),
      child: AnimatedContainer(
        duration: _animationDuration,
        curve: _animationCurve,
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: widget.value ? widget.activeColor : _inactiveBackgroundColor,
          borderRadius: effectiveRadius,
          border: Border.all(
            color: widget.value ? widget.activeColor : widget.inactiveColor,
            width: _borderWidth,
          ),
        ),
        child: widget.value
            ? Icon(Icons.check, color: _checkmarkColor, size: effectiveSize * _checkmarkScale)
            : null,
      ),
    );
  }
}
