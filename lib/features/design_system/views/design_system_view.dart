import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../viewmodels/design_system_viewmodel.dart';
import '../widgets/buttons_section.dart';
import '../widgets/feedback_dialogs_section.dart';
import '../widgets/inputs_section.dart';
import '../widgets/selectors_section.dart';

class DesignSystemView extends ConsumerWidget {
  const DesignSystemView({super.key});

  static const List<String> _categories = [
    'All Components',
    'Buttons',
    'Inputs',
    'Selectors',
    'Feedback & Modals',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(designSystemViewModelProvider);
    final viewModel = ref.read(designSystemViewModelProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      appBar: const CustomAppBar(
        title: 'Design System Showcase',
        hasLeading: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Interactive Category Filter Bar
            Container(
              height: 48.h,
              margin: EdgeInsets.symmetric(vertical: 8.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                itemCount: _categories.length,
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemBuilder: (context, index) {
                  final isSelected = state.selectedCategory == index;
                  return ChoiceChip(
                    label: Text(
                      _categories[index],
                      style: AppTexts.txsr.copyWith(
                        color: isSelected ? Colors.black : AppColors.textPrimary,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.appPrimaryColor,
                    backgroundColor: AppColors.containerBackground,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.appPrimaryColor
                          : Colors.white.withValues(alpha: 0.12),
                    ),
                    onSelected: (_) => viewModel.selectCategory(index),
                  );
                },
              ),
            ),

            // Live interaction log pill
            Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: AppColors.containerBackground,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(
                  color: AppColors.appPrimaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.terminal_rounded,
                    color: AppColors.appPrimaryColor,
                    size: 16.r,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Log: ${state.lastAction}',
                      style: AppTexts.txsr.copyWith(
                        color: AppColors.appPrimaryColor,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // Component Showcase List
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                children: [
                  if (state.selectedCategory == 0 || state.selectedCategory == 1)
                    const ButtonsSection(),
                  if (state.selectedCategory == 0 || state.selectedCategory == 2)
                    const InputsSection(),
                  if (state.selectedCategory == 0 || state.selectedCategory == 3)
                    const SelectorsSection(),
                  if (state.selectedCategory == 0 || state.selectedCategory == 4)
                    const FeedbackDialogsSection(),
                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
