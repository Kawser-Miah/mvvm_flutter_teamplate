import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../constants/app_texts.dart';
import 'custom_svg.dart';

class BillingBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final String? icon;
  final VoidCallback? onTap;

  const BillingBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badge = Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            CustomSvg(asset: icon!, size: 11.r, color: color),
            SizedBox(width: 4.w),
          ],
          Text(
            label,
            style: AppTexts.txss.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: badge);
    }
    return badge;
  }
}
