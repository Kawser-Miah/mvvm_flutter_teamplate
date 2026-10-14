import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _defaultLoaderColor = AppColors.appPrimaryColor;

// ──────────────────────────────────────────────

class CustomLoading extends StatelessWidget {
  final Color? color;
  const CustomLoading({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: color ?? _defaultLoaderColor),
    );
  }
}
