import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/app_colors.dart';
import '../utils/app_icons.dart';
import '../utils/custom_svg.dart';

class StarRatingRow extends StatelessWidget {
  final int rating;
  final ValueChanged<int> onRatingChanged;

  const StarRatingRow({
    super.key,
    required this.rating,
    required this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        final starIndex = index + 1;
        final isFilled = starIndex <= rating;
        return GestureDetector(
          onTap: () => onRatingChanged(starIndex),
          child: Container(
            width: 48.w,
            height: 48.h,
            decoration: const BoxDecoration(
              color: Color(0x33FFBE42),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CustomSvg(
                asset: AppIcons.star,
                size: 24.r,
                color: isFilled
                    ? AppColors.appSecondaryColor
                    : AppColors.yellow.withValues(alpha: 0.4),
              ),
            ),
          ),
        );
      }),
    );
  }
}
