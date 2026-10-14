import 'package:guard_well/core/controllers/bottom_navbar_controller.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/utils/app_icons.dart';
import 'package:guard_well/core/utils/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../network/websocket/active_chat_tracker.dart';

// Colors
const _navbarBackgroundColor = Color(0xFF1C253B);
const _selectedColor = AppColors.appPrimaryColor;
final _unselectedColor = AppColors.gray[400];

// Sizing
double get _iconSize => 24.r;
double get _labelSpacing => 4.h;
double get _fontSize => 12.sp;

class CustomBottomNavbar extends ConsumerWidget {
  final int? index;
  final Function(int)? onChanged;
  const CustomBottomNavbar({super.key, this.index, this.onChanged});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riverpodIndex = ref.watch(clientBottomNavbarIndexProvider);
    final currentIndex = index ?? riverpodIndex;

    return Container(
      decoration: BoxDecoration(
        color: _navbarBackgroundColor,
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              item(context, ref, "Home", AppIcons.home, 0, currentIndex),
              item(context, ref, "Chat", AppIcons.chat, 1, currentIndex),
              item(context, ref, "Favorites", AppIcons.favorites, 2, currentIndex),
              item(context, ref, "Bookings", AppIcons.bookings, 3, currentIndex),
              item(context, ref, "Profile", AppIcons.person, 4, currentIndex),
            ],
          ),
        ),
      ),
    );
  }

  Widget item(BuildContext context, WidgetRef ref, String name, String icon, int pos, int currentIndex) {
    final bool isSelected = pos == currentIndex;
    final Color color = isSelected ? _selectedColor : _unselectedColor!;
    final unreadMessages = pos == 1 ? ref.watch(unreadMessagesCountProvider) : 0;

    return Expanded(
      child: InkWell(
        onTap: () {
          ref.read(clientBottomNavbarIndexProvider.notifier).setIndex(pos);
          if (onChanged != null) onChanged!(pos);
        },
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomSvg(asset: icon, size: _iconSize, color: color),
                if (pos == 1 && unreadMessages > 0)
                  Positioned(
                    right: -6.w,
                    top: -4.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 4.w,
                        vertical: 1.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 16.r,
                        minHeight: 16.r,
                      ),
                      child: Text(
                        unreadMessages > 99 ? '99+' : '$unreadMessages',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: _labelSpacing),
            Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: _fontSize,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
