import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/utils/app_icons.dart';
import 'package:guard_well/core/utils/app_texts.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

// Sizing defaults
double get _defaultRadius => 12.r;
double get _defaultHeight => 50.h;

class CustomDropDown extends StatefulWidget {
  final String? title;
  final bool isRequired;
  final int? initialPick;
  final String? hintText;
  final List<String> options;
  final double? height;
  final double? width;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final void Function(String)? onChanged;

  const CustomDropDown({
    super.key,
    this.title,
    this.isRequired = false,
    this.initialPick,
    this.hintText,
    required this.options,
    this.onChanged,
    this.radius,
    this.height,
    this.width,
    this.backgroundColor,
    this.borderColor,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? currentVal;
  bool isExpanded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialPick != null) {
      currentVal = widget.options[widget.initialPick!];
    }
  }

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = widget.radius ?? _defaultRadius;
    final effectiveHeight = widget.height ?? _defaultHeight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title != null)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Text.rich(
              TextSpan(
                text: widget.title!,
                style: AppTexts.tmdr,
                children: [
                  if (widget.isRequired)
                    const TextSpan(
                      text: ' *',
                      style: TextStyle(color: AppColors.red),
                    ),
                ],
              ),
            ),
          ),
        Container(
          width: widget.width ?? double.infinity,
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.containerBackground,
            borderRadius: BorderRadius.circular(effectiveRadius),
            // border: Border.all(
            //   color: widget.borderColor ?? AppColors.gray.shade200,
            //   width: 1.0,
            // ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => setState(() => isExpanded = !isExpanded),
                behavior: HitTestBehavior.translucent,
                child: Container(
                  height: effectiveHeight,
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: Row(
                    children: [
                      Text(
                        currentVal ?? widget.hintText ?? 'Select One',
                        style: AppTexts.txsr.copyWith(),
                      ),
                      const Spacer(),
                      AnimatedRotation(
                        duration: const Duration(milliseconds: 150),
                        turns: isExpanded ? 0.5 : 0,
                        child: SvgPicture.asset(
                          AppIcons.arrowDown,
                          width: 18.r,
                          colorFilter: ColorFilter.mode(
                            AppColors.gray.shade500,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSize(
                duration: const Duration(milliseconds: 150),
                child: isExpanded
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: widget.options.map((e) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                isExpanded = false;
                                currentVal = e;
                                if (widget.onChanged != null) {
                                  widget.onChanged!(e);
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 10.h,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(e, style: AppTexts.txsr),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
