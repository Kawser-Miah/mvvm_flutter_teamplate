import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_icons.dart';
import 'package:guard_well/core/constants/app_texts.dart';
import 'package:guard_well/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Card colors
final _cardBackgroundColor = AppColors.black.shade400;
const _cardBorderColor = AppColors.black;
const _dividerColor = AppColors.black;

// Icon box
const _iconBoxColor = AppColors.black;
const _iconBoxSize = 50.0;
const _iconBoxRadius = 16.0;

// Title colors
final _premiumTitleColor = AppColors.black[50]!;
final _normalTitleColor = AppColors.black.shade200;
const _premiumSubtitleColor = AppColors.black;
final _normalSubtitleColor = AppColors.black[50]!;

// Feature list colors
final _featuresLabelColor = AppColors.black[50]!;
final _featureTextColor = AppColors.black[100]!;

// Sizing
const _cardRadius = 16.0;
const _headerHorizontalPadding = 35.0;
const _headerTopPadding = 24.0;
const _headerBottomPadding = 20.0;
const _headerItemSpacing = 16.0;
const _dividerHeight = 0.5;
const _featuresTopSpacing = 20.0;
const _featuresHorizontalPadding = 35.0;
const _featureItemSpacing = 12.0;
const _featureIconTextSpacing = 8.0;
const _buttonTopSpacing = 24.0;
const _buttonHorizontalPadding = 18.0;
const _bottomSpacing = 20.0;

// Typography
final _titleStyle = AppTexts.tlgm;
final _featuresLabelStyle = AppTexts.tmdm;
final _featureItemStyle = AppTexts.tmdm;

// ──────────────────────────────────────────────

class SubscriptionWidget extends StatelessWidget {
  final String icon;
  final String title;
  final String subTitle;
  final List<String> pros;
  final List<String> cons;
  final bool isPurchased;
  final bool isPremium;
  final Function()? onTap;
  const SubscriptionWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    this.pros = const [],
    this.cons = const [],
    this.isPurchased = false,
    this.isPremium = false,
    this.onTap,
  });

  SubscriptionWidget copyWith({
    String? icon,
    String? title,
    String? subTitle,
    List<String>? pros,
    List<String>? cons,
    bool? isPurchased,
    Function()? onTap,
  }) {
    return SubscriptionWidget(
      icon: icon ?? this.icon,
      title: title ?? this.title,
      subTitle: subTitle ?? this.subTitle,
      pros: pros ?? this.pros,
      cons: cons ?? this.cons,
      isPurchased: isPurchased ?? this.isPurchased,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _cardBackgroundColor,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: isPurchased ? Border.all(color: _cardBorderColor) : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: _headerHorizontalPadding,
              right: _headerHorizontalPadding,
              top: _headerTopPadding,
              bottom: _headerBottomPadding,
            ),
            child: Row(
              spacing: _headerItemSpacing,
              children: [
                Container(
                  height: _iconBoxSize,
                  width: _iconBoxSize,
                  decoration: BoxDecoration(
                    color: _iconBoxColor,
                    borderRadius: BorderRadius.circular(_iconBoxRadius),
                  ),
                  child: Center(child: SvgPicture.asset(icon)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: _titleStyle.copyWith(
                        color: isPremium
                            ? _premiumTitleColor
                            : _normalTitleColor,
                      ),
                    ),
                    Text(
                      subTitle,
                      style: _titleStyle.copyWith(
                        color: isPremium
                            ? _premiumSubtitleColor
                            : _normalSubtitleColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: _dividerHeight,
            width: double.infinity,
            color: _dividerColor,
          ),
          const SizedBox(height: _featuresTopSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _featuresHorizontalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _featureItemSpacing,
              children: [
                Text(
                  "Features",
                  style: _featuresLabelStyle.copyWith(
                    color: _featuresLabelColor,
                  ),
                ),
                ...pros.map((e) {
                  return Row(
                    spacing: _featureIconTextSpacing,
                    children: [
                      SvgPicture.asset(AppIcons.person),
                      Text(
                        e,
                        style: _featureItemStyle.copyWith(
                          color: _featureTextColor,
                        ),
                      ),
                    ],
                  );
                }),
                ...cons.map((e) {
                  return Row(
                    spacing: _featureIconTextSpacing,
                    children: [
                      SvgPicture.asset(AppIcons.person),
                      Text(
                        e,
                        style: _featureItemStyle.copyWith(
                          color: _featureTextColor,
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: _buttonTopSpacing),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: _buttonHorizontalPadding,
            ),
            child: CustomButton(
              text: isPurchased ? "Current Plan" : "Choose Plan",
              leading: isPurchased ? AppIcons.person : null,
              isSecondary: isPurchased,
              onTap: isPurchased ? null : onTap,
            ),
          ),
          const SizedBox(height: _bottomSpacing),
        ],
      ),
    );
  }
}
