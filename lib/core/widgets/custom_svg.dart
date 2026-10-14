import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSvg extends StatelessWidget {
  final String asset;
  final Color? color;
  final double? width;
  final double? size;
  final double? height;
  const CustomSvg({
    super.key,
    required this.asset,
    this.color,
    this.size,
    this.height,
    this.width,
  });

  IconData _getFallbackIcon(String path) {
    if (path.contains('eye_off')) return Icons.visibility_off;
    if (path.contains('eye')) return Icons.visibility;
    if (path.contains('arrow_down')) return Icons.keyboard_arrow_down;
    if (path.contains('star')) return Icons.star;
    if (path.contains('person') || path.contains('account')) return Icons.person;
    if (path.contains('home')) return Icons.home;
    if (path.contains('lock')) return Icons.lock;
    if (path.contains('search')) return Icons.search;
    if (path.contains('edit')) return Icons.edit;
    if (path.contains('back')) return Icons.arrow_back;
    return Icons.widgets_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = size ?? height ?? width ?? 20;

    return asset.contains(".svg")
        ? SvgPicture.asset(
            asset,
            height: size ?? height,
            width: size ?? width,
            colorFilter:
                color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                _getFallbackIcon(asset),
                size: effectiveSize,
                color: color,
              );
            },
          )
        : CachedNetworkImage(
            imageUrl: asset,
            height: size ?? height,
            width: size ?? width,
            errorWidget: (context, url, error) => Icon(
              Icons.broken_image,
              size: effectiveSize,
              color: color,
            ),
          );
  }
}
