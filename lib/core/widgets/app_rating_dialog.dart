import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../model/rating/app_rating_request.dart';
import '../../model/rating/user_home_repository.dart';
import '../utils/custom_snackbar.dart';
import 'base_review_dialog.dart';

/// App rating dialog for users and coaches to rate the Coach Hub platform.
class AppRatingDialog extends ConsumerWidget {
  final VoidCallback? onRatingSubmitted;

  const AppRatingDialog({
    super.key,
    this.onRatingSubmitted,
  });

  static Future<void> show(
    BuildContext context, {
    VoidCallback? onRatingSubmitted,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AppRatingDialog(
        onRatingSubmitted: onRatingSubmitted,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BaseReviewDialog(
      title: 'How was your experience with\nCoach Hub?',
      onSubmit: (rating, review) async {
        final request = AppRatingRequest(
          rating: rating,
          review: review,
        );

        final repo = ref.read(userHomeRepositoryProvider);
        final result = await repo.submitAppRating(request);

        if (!context.mounted) return;

        if (result.isSuccess) {
          Navigator.pop(context);
          AppSnackBar.showSuccess(
            context,
            result.dataOrNull?.message ?? 'App rating submitted successfully.',
          );
          onRatingSubmitted?.call();
        } else {
          AppSnackBar.showError(
            context,
            result.errorMessage ?? 'Failed to submit app rating.',
          );
        }
      },
    );
  }
}
