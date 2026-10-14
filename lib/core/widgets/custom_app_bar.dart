import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_texts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import 'back_pill.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
const _backgroundColor = AppColors.scaffoldBackgroundColor;
const _titleColor = AppColors.textPrimary;
const _dividerColor = Colors.transparent;

// Sizing
double get _appBarHeight => 44.h;
double get _leadingStartPadding => 16.w;
double get _titleLeftPadding => 24.w;
const _dividerHeight = 0.0;

// Typography
final _titleStyle = AppTexts.txls;

// ──────────────────────────────────────────────

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool hasLeading;
  final Color backgroundColor;
  final Widget? trailing;
  const CustomAppBar({
    super.key,
    required this.title,
    this.hasLeading = true,
    this.backgroundColor = _backgroundColor,
    this.trailing,
  });

  @override
  Size get preferredSize => Size(double.infinity, kToolbarHeight.h);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: SizedBox(
        height: _appBarHeight,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: _leadingStartPadding),
            if (hasLeading) const BackPill(),
            SizedBox(width: _titleLeftPadding),
            Expanded(
              child: Text(
                title,
                style: _titleStyle.copyWith(color: _titleColor),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (trailing != null) ...[
              trailing!,
              SizedBox(width: 16.w),
            ],
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(_dividerHeight),
        child: Container(
          height: _dividerHeight,
          width: double.infinity,
          color: _dividerColor,
        ),
      ),
    );
  }
}