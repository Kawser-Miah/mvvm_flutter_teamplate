import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/back_pill.dart';
import '../../../core/widgets/custom_button.dart';
import '../viewmodels/design_system_viewmodel.dart';
import 'component_section_card.dart';

class ButtonsSection extends ConsumerWidget {
  const ButtonsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designSystemViewModelProvider);
    final viewModel = ref.read(designSystemViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentSectionCard(
          title: 'CustomButton (Primary & Secondary)',
          description: 'Gradient filled & secondary outline pills with state controls.',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Loading',
                style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
              ),
              Switch(
                value: state.isButtonLoading,
                activeThumbColor: AppColors.appPrimaryColor,
                onChanged: (_) => viewModel.toggleButtonLoading(),
              ),
            ],
          ),
          child: Column(
            children: [
              CustomButton(
                text: 'Primary Action Button',
                isLoading: state.isButtonLoading,
                isDisabled: state.isButtonDisabled,
                onTap: () => viewModel.logAction('Tapped Primary CustomButton'),
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Secondary Action Button',
                isSecondary: true,
                isLoading: state.isButtonLoading,
                isDisabled: state.isButtonDisabled,
                onTap: () => viewModel.logAction('Tapped Secondary CustomButton'),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Compact Left',
                      height: 42.h,
                      onTap: () => viewModel.logAction('Tapped Compact Left Button'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomButton(
                      text: 'Disabled State',
                      isDisabled: true,
                      height: 42.h,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ComponentSectionCard(
          title: 'AppButton & BackPill',
          description: 'Rectangular core buttons and navigation back pills.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButton(
                text: 'Standard AppButton',
                onPressed: () => viewModel.logAction('Tapped AppButton'),
              ),
              SizedBox(height: 12.h),
              const AppButton(
                text: 'Loading AppButton',
                isLoading: true,
              ),
              SizedBox(height: 16.h),
              Text(
                'Back Pill Navigation Widget:',
                style: AppTexts.txsr.copyWith(color: AppColors.textSecondary),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  BackPill(
                    onTap: () => viewModel.logAction('Tapped BackPill'),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Tap to test back pill interaction',
                    style: AppTexts.txsr.copyWith(color: AppColors.textPrimary),
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
