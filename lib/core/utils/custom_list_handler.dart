import 'package:flutter/material.dart';
import 'package:guard_well/core/utils/app_colors.dart';
import 'package:guard_well/core/widgets/custom_loading.dart';

class CustomListHandler extends StatelessWidget {
  final Future<void> Function()? onRefresh;
  final Future<void> Function()? onLoadMore;
  final double scrollThreshold;
  final double horizontalPadding;
  final double spacing;
  final Widget? child;
  final List<Widget> children;
  final String endIndicator;
  final String placeholder;
  final TextStyle textStyle;
  final bool reverse;
  final bool topPadding;
  final bool isLoading;
  final bool isLoadingMore;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  const CustomListHandler({
    super.key,
    this.child,
    this.children = const [],
    this.onRefresh,
    this.onLoadMore,
    this.reverse = false,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.topPadding = false,
    this.endIndicator = "End of the list",
    this.placeholder = "Nothing to show",
    this.textStyle = const TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.w300,
    ),
    this.scrollThreshold = 200,
    this.spacing = 12,
    this.horizontalPadding = 20,
    this.controller,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (onLoadMore == null || isLoadingMore || isLoading) {
          return false;
        }

        final metrics = scrollInfo.metrics;

        if (!metrics.hasContentDimensions || metrics.maxScrollExtent <= 0) {
          return false;
        }

        final shouldLoadMore = reverse
            ? metrics.pixels <= metrics.minScrollExtent + scrollThreshold
            : metrics.pixels >= metrics.maxScrollExtent - scrollThreshold;

        if (shouldLoadMore) {
          onLoadMore!();
        }

        return false;
      },
      child: isLoading
          ? Center(child: CustomLoading())
          : reverse
          ? getChild() ?? getChildren()
          : RefreshIndicator(
              onRefresh: onRefresh ?? () async {},
              color: AppColors.black,
              backgroundColor: AppColors.gray[25],
              child: getChild() ?? getChildren(),
            ),
    );
  }

  SingleChildScrollView? getChild() {
    if (child == null) {
      return null;
    }
    return SingleChildScrollView(
      controller: controller,
      clipBehavior: Clip.none,
      reverse: reverse,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: SafeArea(child: child!),
    );
  }

  ListView getChildren() {
    return ListView.separated(
      controller: controller,
      reverse: reverse,
      physics: physics ?? const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: spacing,
      ),
      itemBuilder: (context, index) {
        if (index == children.length) {
          if (children.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(placeholder, style: textStyle),
              ),
            );
          }
          if (isLoadingMore) {
            return Center(child: CustomLoading());
          }
          return SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(endIndicator, style: textStyle),
              ),
            ),
          );
        }
        return children[index];
      },
      separatorBuilder: (context, index) {
        return SizedBox(height: spacing);
      },
      itemCount: children.length + 1,
    );
  }
}
