import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/billing_badge.dart';
import '../../../core/widgets/custom_checkbox.dart';
import '../../../core/widgets/custom_drop_down.dart';
import '../../../core/widgets/star_rating_row.dart';
import '../viewmodels/design_system_viewmodel.dart';
import 'component_section_card.dart';

class SelectorsSection extends ConsumerWidget {
  const SelectorsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designSystemViewModelProvider);
    final viewModel = ref.read(designSystemViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentSectionCard(
          title: 'CustomDropDown',
          description: 'Animated expandable dropdown selection component.',
          child: CustomDropDown(
            title: 'Protection Plan Tier',
            isRequired: true,
            hintText: 'Select a plan',
            options: const [
              'Basic Security (\$19/mo)',
              'Standard Plan (\$49/mo)',
              'Enterprise Armor (\$99/mo)',
              'Custom Executive VIP',
            ],
            initialPick: 1,
            onChanged: (val) => viewModel.setSelectedDropdown(val),
          ),
        ),
        ComponentSectionCard(
          title: 'StarRatingRow & Interactive Rating',
          description: '5-star interactive rating row with active fill and animation.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StarRatingRow(
                rating: state.starRating,
                onRatingChanged: (rating) => viewModel.setStarRating(rating),
              ),
              SizedBox(height: 12.h),
              Text(
                'Current Rating: ${state.starRating} of 5 Stars',
                style: AppTexts.txsr.copyWith(color: AppColors.appSecondaryColor),
              ),
            ],
          ),
        ),
        ComponentSectionCard(
          title: 'CustomCheckBox & BillingBadge',
          description: 'Togglable animated checkbox and status pill badges.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CustomCheckBox(
                    value: state.checkboxValue,
                    activeColor: AppColors.appPrimaryColor,
                    onChanged: (val) => viewModel.setCheckboxValue(val),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'I agree to terms & security protocols (Interactive)',
                      style: AppTexts.txsr.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Text(
                'Status & Billing Badges:',
                style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 12.h),
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: [
                  BillingBadge(
                    label: 'ACTIVE',
                    color: AppColors.appPrimaryColor,
                    bgColor: AppColors.appPrimaryColor.withValues(alpha: 0.15),
                    onTap: () => viewModel.logAction('Tapped ACTIVE badge'),
                  ),
                  BillingBadge(
                    label: 'PENDING',
                    color: AppColors.appSecondaryColor,
                    bgColor: AppColors.appSecondaryColor.withValues(alpha: 0.15),
                    onTap: () => viewModel.logAction('Tapped PENDING badge'),
                  ),
                  BillingBadge(
                    label: 'OVERDUE',
                    color: AppColors.red.shade400,
                    bgColor: AppColors.red.withValues(alpha: 0.15),
                    onTap: () => viewModel.logAction('Tapped OVERDUE badge'),
                  ),
                  BillingBadge(
                    label: 'PRO VIP',
                    color: AppColors.infoBlue,
                    bgColor: AppColors.infoBlue.withValues(alpha: 0.15),
                    onTap: () => viewModel.logAction('Tapped PRO VIP badge'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
