// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:guard_well/core/widgets/custom_networked_image.dart';
// import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
//
// double get _defaultRadius => 22.r;
//
// /// Backwards-compatible wrapper delegating to [CustomNetworkedImage].
// class UserAvatar extends StatelessWidget {
//   final String? imagePath;
//   final File? imageFile;
//   final double? radius;
//   final Color? backgroundColor;
//   final Color? borderColor;
//   final double? borderWidth;
//   final VoidCallback? onTap;
//
//   const UserAvatar({
//     super.key,
//     this.imagePath,
//     this.imageFile,
//     this.radius,
//     this.backgroundColor,
//     this.borderColor,
//     this.borderWidth,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final effectiveRadius = radius ?? _defaultRadius;
//     final double size = effectiveRadius * 2;
//     final String? imgUrl = imageFile?.path ?? imagePath;
//
//     final child = CustomNetworkedImage(
//       url: imgUrl,
//       width: size,
//       height: size,
//       radius: effectiveRadius,
//     );
//
//     if (onTap != null) {
//       return GestureDetector(onTap: onTap, child: child);
//     }
//     return child;
//   }
// }
