import 'dart:io';
import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:guard_well/core/constants/app_icons.dart';
import 'package:guard_well/core/widgets/custom_image_picker.dart';
import 'package:guard_well/core/widgets/custom_svg.dart';
import 'package:guard_well/core/widgets/custom_networked_image.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Sizing
double get _defaultSize => 100.r;
double get _avatarBorderWidth => 3.w;
const _avatarBorderColor = AppColors.white;

class ProfilePicture extends StatelessWidget {
  final double? size;
  final String? image;
  final File? imageFile;
  final bool showLoading;
  final bool isEditable;
  final Function(File)? imagePickerCallback;

  const ProfilePicture({
    super.key,
    this.image,
    this.size,
    this.showLoading = true,
    this.isEditable = false,
    this.imagePickerCallback,
    this.imageFile,
  });

  Widget _buildDefaultAvatar(double effectiveSize) {
    return Container(
      width: effectiveSize,
      height: effectiveSize,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C384E),
            Color(0xFF161F30),
          ],
        ),
      ),
      child: Center(
        child: CustomSvg(
          asset: AppIcons.person,
          size: effectiveSize * 0.44,
          color: AppColors.appPrimaryColor,
        ),
      ),
    );
  }

  Widget _buildImage(double effectiveSize) {
    if (imageFile != null) {
      return Image.file(
        imageFile!,
        width: effectiveSize,
        height: effectiveSize,
        fit: BoxFit.cover,
      );
    }

    if (image == null || image!.isEmpty) {
      return _buildDefaultAvatar(effectiveSize);
    }

    return CustomNetworkedImage(
      url: image,
      width: effectiveSize,
      height: effectiveSize,
      radius: effectiveSize / 2,
      shimmer: showLoading,
      fallbackWidget: _buildDefaultAvatar(effectiveSize),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? _defaultSize;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (!isEditable) {
          return;
        }

        File? pickedImage = await customImagePicker();

        if (pickedImage != null && imagePickerCallback != null) {
          imagePickerCallback!(pickedImage);
        }
      },
      child: SizedBox(
        width: effectiveSize,
        height: effectiveSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: effectiveSize,
              height: effectiveSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: _avatarBorderColor,
                  width: _avatarBorderWidth,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(effectiveSize / 2),
                child: _buildImage(effectiveSize),
              ),
            ),
            if (isEditable)
              Positioned(
                bottom: 2.h,
                right: 2.w,
                child: Container(
                  width: 28.r,
                  height: 28.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2CC36A),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.w),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: Colors.white,
                      size: 14.r,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}