import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:guard_well/core/utils/app_colors.dart';

/// Helper to pick images from gallery, with optional cropping disabled by default.
Future<File?> customImagePicker({
  bool enableCrop = false,
  bool isCircular = false,
  bool isSquared = false,
}) async {
  final picker = ImagePicker();

  final XFile? pickedImage = await picker.pickImage(
    source: ImageSource.gallery,
  );

  if (pickedImage == null) return null;

  if (!enableCrop) {
    return File(pickedImage.path);
  }

  final cropper = ImageCropper();
  final CroppedFile? croppedImage = await cropper.cropImage(
    sourcePath: pickedImage.path,
    uiSettings: [
      AndroidUiSettings(
        toolbarTitle: 'Crop your image',
        toolbarColor: AppColors.black,
        toolbarWidgetColor: Colors.blue[50],
        backgroundColor: AppColors.black,
        statusBarLight: false,
        cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
        hideBottomControls: isSquared,
        initAspectRatio: CropAspectRatioPreset.square,
      ),
      IOSUiSettings(
        cropStyle: isCircular ? CropStyle.circle : CropStyle.rectangle,
        showCancelConfirmationDialog: true,
      ),
    ],
  );

  if (croppedImage != null) {
    return File(croppedImage.path);
  }

  return null;
}
