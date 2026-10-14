import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/app_texts.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/app_loader.dart';
import '../../../core/widgets/base_review_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_loading.dart';
import '../../../core/widgets/overlay_confirmation.dart';
import '../../../core/widgets/profile_picture.dart';
import '../viewmodels/design_system_viewmodel.dart';
import 'component_section_card.dart';

class FeedbackDialogsSection extends ConsumerWidget {
  const FeedbackDialogsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(designSystemViewModelProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ComponentSectionCard(
          title: 'Dialogs & Modal Overlays',
          description: 'Triggerable confirmation and review dialogs.',
          child: Column(
            children: [
              CustomButton(
                text: 'Test OverlayConfirmation Dialog',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => OverlayConfirmation(
                      title: 'Terminate Security Session?',
                      subtitle: 'Are you sure you want to proceed?',
                      highlight: 'This action cannot be undone.',
                      buttonTextLeft: 'Cancel',
                      buttonTextRight: 'Confirm',
                      buttonCallBackLeft: () {
                        Navigator.pop(dialogCtx);
                        viewModel.logAction('Cancelled OverlayConfirmation');
                      },
                      buttonCallBackRight: () {
                        Navigator.pop(dialogCtx);
                        viewModel.logAction('Confirmed OverlayConfirmation');
                      },
                    ),
                  );
                },
              ),
              SizedBox(height: 12.h),
              CustomButton(
                text: 'Test BaseReviewDialog',
                isSecondary: true,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (dialogCtx) => BaseReviewDialog(
                      title: 'How was your experience with Guard Well?',
                      hintText: 'Describe your feedback or thoughts',
                      onSubmit: (rating, review) async {
                        Navigator.pop(dialogCtx);
                        viewModel.logAction('Review submitted: $rating stars - "$review"');
                        AppSnackBar.show(
                          context,
                          message: 'Review saved with rating $rating★',
                          type: SnackBarType.success,
                        );
                      },
                      onCancel: () => Navigator.pop(dialogCtx),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        ComponentSectionCard(
          title: 'SnackBars & Notifications',
          description: 'Custom stylized notifications with colored borders & badges.',
          child: Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appPrimaryColor,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  AppSnackBar.show(
                    context,
                    title: 'Success',
                    message: 'Protection shield is fully active.',
                    type: SnackBarType.success,
                  );
                  viewModel.logAction('Shown Success SnackBar');
                },
                child: const Text('Success'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.red.shade400,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  AppSnackBar.show(
                    context,
                    title: 'Error Alert',
                    message: 'Network link timed out. Please retry.',
                    type: SnackBarType.error,
                  );
                  viewModel.logAction('Shown Error SnackBar');
                },
                child: const Text('Error'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.appSecondaryColor,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  AppSnackBar.show(
                    context,
                    title: 'Attention',
                    message: 'Your biometric session expires in 2 mins.',
                    type: SnackBarType.warning,
                  );
                  viewModel.logAction('Shown Warning SnackBar');
                },
                child: const Text('Warning'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.infoBlue,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  AppSnackBar.show(
                    context,
                    title: 'System Info',
                    message: 'Cloud sync updated to version 1.2.0.',
                    type: SnackBarType.info,
                  );
                  viewModel.logAction('Shown Info SnackBar');
                },
                child: const Text('Info'),
              ),
            ],
          ),
        ),
        ComponentSectionCard(
          title: 'Avatars & Loading Indicators',
          description: 'Profile picture avatar components and progress loaders.',
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  ProfilePicture(
                    size: 70.r,
                    isEditable: false,
                  ),
                  SizedBox(height: 8.h),
                  Text('Standard', style: AppTexts.txsr.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Column(
                children: [
                  ProfilePicture(
                    size: 70.r,
                    isEditable: true,
                    imagePickerCallback: (_) => viewModel.logAction('Avatar image picked'),
                  ),
                  SizedBox(height: 8.h),
                  Text('Editable', style: AppTexts.txsr.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Column(
                children: [
                  const CustomLoading(),
                  SizedBox(height: 12.h),
                  Text('CustomLoading', style: AppTexts.txsr.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Column(
                children: [
                  const AppLoader(),
                  SizedBox(height: 12.h),
                  Text('AppLoader', style: AppTexts.txsr.copyWith(color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
