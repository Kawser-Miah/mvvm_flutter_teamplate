import 'package:guard_well/core/controllers/bottom_navbar_controller.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/utils/app_icons.dart';
import 'package:guard_well/core/utils/custom_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';

import '../network/websocket/active_chat_tracker.dart';

const _navbarBackgroundColor = Color(0xFF1C253B);
const _selectedColor = AppColors.appPrimaryColor;
final _unselectedColor = AppColors.gray[400];

// Sizing
double get _iconSize => 24.r;
double get _centerButtonSize => 50.r;
double get _labelSpacing => 2.h;
double get _fontSize => 11.sp;

class ProviderCustomBottomNavbar extends ConsumerWidget {
  final int? index;
  final Function(int)? onChanged;

  const ProviderCustomBottomNavbar({
    super.key,
    this.index,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riverpodIndex = ref.watch(providerBottomNavbarIndexProvider);
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
        child: SizedBox(
          height: 64.h,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                    _buildStandardItem(
                      context: context,
                      ref: ref,
                      name: "Dashboard",
                      icon: AppIcons.dashboard,
                      pos: 0,
                      currentIndex: currentIndex,
                    ),
                    _buildStandardItem(
                      context: context,
                      ref: ref,
                      name: "Bookings",
                      icon: AppIcons.bookings,
                      pos: 1,
                      currentIndex: currentIndex,
                    ),
                    _buildCenterLabel(ref: ref, pos: 2),
                    _buildStandardItem(
                      context: context,
                      ref: ref,
                      name: "Messages",
                      icon: AppIcons.chat,
                      pos: 3,
                      currentIndex: currentIndex,
                    ),
                    _buildStandardItem(
                      context: context,
                      ref: ref,
                      name: "Profile",
                      icon: AppIcons.person,
                      pos: 4,
                      currentIndex: currentIndex,
                    ),
                  ],
                ),
              ),
            ),
              Positioned(
                top: -16.h,
                child: _buildCenterButton(ref: ref, pos: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStandardItem({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String icon,
    required int pos,
    required int currentIndex,
  }) {
    final bool isSelected = pos == currentIndex;
    final Color color = isSelected ? _selectedColor : _unselectedColor!;
    final unreadMessages = pos == 3 ? ref.watch(unreadMessagesCountProvider) : 0;

    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelect(ref, pos),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                CustomSvg(
                  asset: icon,
                  size: _iconSize,
                  color: color,
                ),
                if (pos == 3 && unreadMessages > 0)
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
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterLabel({required WidgetRef ref, required int pos}) {
    return Expanded(
      child: InkWell(
        onTap: () => _onTabSelect(ref, pos),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: _iconSize),
            SizedBox(height: _labelSpacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  "Services",
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w600,
                    color: _selectedColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCenterButton({
    required WidgetRef ref,
    required int pos,
  }) {
    return InkWell(
      onTap: () => _onTabSelect(ref, pos),
      customBorder: const CircleBorder(),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        width: _centerButtonSize,
        height: _centerButtonSize,
        decoration: const BoxDecoration(
          color: _selectedColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x402CC36A),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 26.r,
          ),
        ),
      ),
    );
  }

  void _onTabSelect(WidgetRef ref, int pos) {
    ref.read(providerBottomNavbarIndexProvider.notifier).setIndex(pos);
    if (onChanged != null) onChanged!(pos);
  }
}