import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_texts.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

enum SnackBarType { success, error, info, warning }

class AppSnackBar {
  static void show(
    BuildContext? context, {
    required String message,
    String? title,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onAction,
    String? actionLabel,
  }) {
    final (Color primaryColor, Color bgColor, Color borderColor, IconData iconData) =
        switch (type) {
      SnackBarType.success => (
        AppColors.appPrimaryColor,
        const Color(0xFF0D2818),
        AppColors.appPrimaryColor.withValues(alpha: 0.4),
        Icons.check_circle_rounded,
      ),
      SnackBarType.error => (
        AppColors.red.shade400,
        const Color(0xFF2A0D0D),
        AppColors.red.withValues(alpha: 0.4),
        Icons.error_rounded,
      ),
      SnackBarType.warning => (
        AppColors.appSecondaryColor,
        const Color(0xFF291F0A),
        AppColors.appSecondaryColor.withValues(alpha: 0.4),
        Icons.warning_amber_rounded,
      ),
      SnackBarType.info => (
        AppColors.infoBlue,
        const Color(0xFF0D1E2A),
        AppColors.infoBlue.withValues(alpha: 0.4),
        Icons.info_rounded,
      ),
    };

    final snackBar = SnackBar(
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.transparent,
      duration: duration,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: EdgeInsets.zero,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.18),
                shape: BoxShape.circle,
              ),
              child: Icon(
                iconData,
                color: primaryColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (title != null && title.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        title,
                        style: AppTexts.tsmb.copyWith(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  Text(
                    message,
                    style: AppTexts.tsmr.copyWith(
                      color: const Color(0xFFE5E7EB),
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(width: 8),
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  actionLabel,
                  style: AppTexts.tsmb.copyWith(
                    color: primaryColor,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );

    if (context != null && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    } else {
      scaffoldMessengerKey.currentState
        ?..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }

  static void showSuccess(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  static void showError(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  static void showWarning(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  static void showInfo(
    BuildContext? context,
    String message, {
    String? title,
    Duration duration = const Duration(seconds: 4),
  }) {
    show(
      context,
      message: message,
      title: title,
      type: SnackBarType.info,
      duration: duration,
    );
  }
}

/// Backwards compatibility helper
void customSnackBar(
  String message, {
  bool isError = true,
  String? title,
  BuildContext? context,
}) {
  if (isError) {
    AppSnackBar.showError(context, message, title: title);
  } else {
    AppSnackBar.showSuccess(context, message, title: title);
  }
}
