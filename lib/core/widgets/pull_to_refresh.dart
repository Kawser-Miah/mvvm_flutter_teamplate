import 'package:flutter/material.dart';
import 'package:guard_well/core/theme/app_colors.dart';

// ──────────────────────────────────────────────
// CUSTOMIZABLE VARIABLES — Change these to style
// ──────────────────────────────────────────────

// Colors
final _indicatorBackgroundColor = AppColors.black[400]!;
final _indicatorShadowColor = AppColors.black[800]!;

// Sizing
const _thresholdMin = 80.0;
const _thresholdMax = 200.0;
const _edgeOffset = 100.0;
const _iconSize = 32.0;
const _indicatorPadding = 4.0;

// Shadow
const _shadowOffset = Offset(0, 2);
const _shadowSpread = 2.0;
const _shadowBlur = 5.0;
const _shadowAlpha = 100;

// ──────────────────────────────────────────────

class PullToRefresh extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final ScrollController? controller;

  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
    this.controller,
  });

  @override
  PullToRefreshState createState() => PullToRefreshState();
}

class PullToRefreshState extends State<PullToRefresh> {
  bool isRefreshing = false;
  double beginY = 0;
  double size = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: start,
      onPanUpdate: update,
      onPanEnd: end,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (widget.controller != null && widget.controller!.offset <= 0) {
                if (notification is ScrollStartNotification) {
                  if (notification.dragDetails != null) {
                    start(notification.dragDetails!);
                  }
                } else if (notification is ScrollUpdateNotification) {
                  if (notification.dragDetails != null) {
                    update(notification.dragDetails!);
                  }
                } else if (notification is ScrollEndNotification) {
                  if (notification.dragDetails != null) {
                    end(notification.dragDetails!);
                  }
                }
              }

              return true;
            },
            child: Padding(
              padding: EdgeInsets.only(
                top: widget.controller != null ? 0 : size,
              ),
              child: widget.child,
            ),
          ),
          Positioned(
            top: getLoadingPosition - _iconSize,
            child: Opacity(
              opacity: getOpacity,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(_indicatorPadding),
                  height: _iconSize,
                  width: _iconSize,
                  decoration: BoxDecoration(
                    color: _indicatorBackgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        offset: _shadowOffset,
                        color: _indicatorShadowColor.withAlpha(_shadowAlpha),
                        spreadRadius: _shadowSpread,
                        blurRadius: _shadowBlur,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.appPrimaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void end(DragEndDetails details) {
    setState(() {
      if (size > _thresholdMin && !isRefreshing) {
        _refresh();
      }
      size = 0;
    });
  }

  void update(DragUpdateDetails details) {
    setState(() {
      final temp = details.localPosition.dy - beginY;
      if (temp > 0 && !isRefreshing) {
        size = temp < _thresholdMax ? temp : _thresholdMax;
      } else {
        size = 0;
      }
    });
  }

  void start(DragStartDetails details) {
    setState(() {
      beginY = details.localPosition.dy;
    });
  }

  double get getLoadingPosition {
    if (size > _edgeOffset || isRefreshing) {
      return _edgeOffset;
    } else {
      return size;
    }
  }

  double get getOpacity {
    if (isRefreshing || size > _edgeOffset) {
      return 1;
    } else if (size == 0) {
      return 0;
    } else if (size <= _edgeOffset) {
      return size / _edgeOffset;
    }

    return 0;
  }

  Future<void> _refresh() async {
    setState(() {
      isRefreshing = true;
    });

    await widget.onRefresh();

    setState(() {
      isRefreshing = false;
    });
  }
}
