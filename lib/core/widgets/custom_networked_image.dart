import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:shimmer/shimmer.dart';

// Sizing
double get _defaultRadius => 10.r;

// Shimmer Animation & Colors
final _shimmerBaseColor = AppColors.black.shade300;
final _shimmerHighlightColor = AppColors.black.shade50;
const _shimmerChildColor = Colors.white;
const _shimmerDuration = Duration(milliseconds: 800);

class CustomNetworkedImage extends StatelessWidget {
  final String? url;
  final double? height;
  final double? width;
  final double? radius;
  final bool shimmer;
  final BoxFit? fit;
  final Widget? fallbackWidget;

  const CustomNetworkedImage({
    super.key,
    this.url,
    this.height,
    this.width,
    this.radius,
    this.fit = BoxFit.cover,
    this.shimmer = true,
    this.fallbackWidget,
  });

  bool get _isNetwork =>
      url != null &&
      url!.isNotEmpty &&
      (url!.startsWith('http://') || url!.startsWith('https://'));

  bool get _isFile =>
      url != null && url!.isNotEmpty && !_isNetwork && File(url!).existsSync();

  Widget _buildPlaceholder(double effectiveRadius) {
    if (fallbackWidget != null) return fallbackWidget!;
    final iconSize =
        (height != null && height! < 30) ? height! * 0.6 : 22.r;
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(effectiveRadius),
      ),
      child: Center(
        child: Icon(
          Icons.person_rounded,
          color: AppColors.gray.shade400,
          size: iconSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius ?? _defaultRadius;

    return ClipRRect(
      borderRadius: BorderRadius.circular(effectiveRadius),
      child: (url == null || url!.isEmpty)
          ? _buildPlaceholder(effectiveRadius)
          : _isNetwork
              ? CachedNetworkImage(
                  imageUrl: url!,
                  height: height,
                  width: width,
                  fit: fit,
                  errorWidget: (context, url, error) =>
                      _buildPlaceholder(effectiveRadius),
                  placeholder: (context, _) {
                    if (!shimmer) {
                      return _buildPlaceholder(effectiveRadius);
                    }
                    return Shimmer.fromColors(
                      baseColor: _shimmerBaseColor,
                      highlightColor: _shimmerHighlightColor,
                      period: _shimmerDuration,
                      child: Container(
                        height: height ?? width,
                        width: width ?? height,
                        color: _shimmerChildColor,
                      ),
                    );
                  },
                )
              : _isFile
                  ? Image.file(File(url!),
                      height: height, width: width, fit: fit)
                  : Image.asset(url!, height: height, width: width, fit: fit),
    );
  }
}