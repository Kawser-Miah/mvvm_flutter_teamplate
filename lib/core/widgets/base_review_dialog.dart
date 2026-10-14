import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../utils/app_colors.dart';
import '../utils/app_texts.dart';
import '../utils/custom_snackbar.dart';
import 'custom_button.dart';
import 'custom_text_field.dart';
import 'star_rating_row.dart';

/// Reusable feedback / review dialog shared across coach reviews and app ratings.
class BaseReviewDialog extends StatefulWidget {
  final String title;
  final String hintText;
  final Future<void> Function(int rating, String review) onSubmit;
  final VoidCallback? onCancel;

  const BaseReviewDialog({
    super.key,
    required this.title,
    this.hintText = 'Share your experience',
    required this.onSubmit,
    this.onCancel,
  });

  @override
  State<BaseReviewDialog> createState() => _BaseReviewDialogState();
}

class _BaseReviewDialogState extends State<BaseReviewDialog> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (_rating <= 0) {
      AppSnackBar.showWarning(context, 'Please select a star rating.');
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      await widget.onSubmit(_rating, _reviewController.text.trim());
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.scaffoldBackgroundColor,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: AppTexts.txsb.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                height: 1.3,
              ),
            ),
            SizedBox(height: 16.h),
            StarRatingRow(
              rating: _rating,
              onRatingChanged: (val) => setState(() => _rating = val),
            ),
            SizedBox(height: 14.h),
            CustomTextField(
              controller: _reviewController,
              hintText: widget.hintText,
              lines: 3,
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Submit',
              isLoading: _isSubmitting,
              onTap: _isSubmitting ? null : _handleSubmit,
              textColor: AppColors.white,
              height: 52.h,
              radius: 16.r,
              fontSize: 16.sp,
            ),
            SizedBox(height: 12.h),
            CustomButton(
              text: 'No thanks',
              onTap: _isSubmitting
                  ? null
                  : (widget.onCancel ?? () => Navigator.pop(context)),
              isSecondary: true,
              textColor: AppColors.white,
              height: 52.h,
              radius: 16.r,
              fontSize: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
