import 'dart:async';

import 'dart:io';
import 'package:guard_well/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'video_player_controls.dart';

/// Opens a dedicated fullscreen modal video player for network URLs or local file paths.
void showCustomVideoPlayer(
  BuildContext context, {
  required String videoUrl,
  String title = 'Introduction Video',
}) {
  showDialog(
    context: context,
    useSafeArea: false,
    builder: (ctx) => CustomVideoPlayerDialog(
      videoUrl: videoUrl,
      title: title,
    ),
  );
}

/// Fullscreen modal video player with scrubbing controls, playback actions, and time indicators.
class CustomVideoPlayerDialog extends StatefulWidget {
  final String videoUrl;
  final String title;

  const CustomVideoPlayerDialog({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<CustomVideoPlayerDialog> createState() => _CustomVideoPlayerDialogState();
}

class _CustomVideoPlayerDialogState extends State<CustomVideoPlayerDialog> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _hasError = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      setState(() {
        _hasError = false;
        _isInitialized = false;
      });

      final url = widget.videoUrl.trim();
      final isNetwork = url.startsWith('http://') || url.startsWith('https://');

      if (isNetwork) {
        _controller = VideoPlayerController.networkUrl(Uri.parse(url));
      } else {
        _controller = VideoPlayerController.file(File(url));
      }

      _controller!.addListener(() {
        if (mounted) setState(() {});
      });

      await _controller!.initialize();
      if (mounted) {
        setState(() => _isInitialized = true);
        unawaited(_controller!.play());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _hasError = true);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    if (duration.inHours > 0) {
      final hours = duration.inHours.toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => setState(() => _showControls = !_showControls),
          behavior: HitTestBehavior.opaque,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(
                child: _isInitialized && _controller != null
                    ? AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: VideoPlayer(_controller!),
                      )
                    : _hasError
                        ? VideoPlayerErrorView(onRetry: _initPlayer)
                        : const CircularProgressIndicator(
                            color: AppColors.appPrimaryColor,
                          ),
              ),
              if (_showControls) ...[
                VideoPlayerTopBar(title: widget.title),
                if (_isInitialized && _controller != null)
                  VideoPlayerCenterPlayButton(
                    isPlaying: _controller!.value.isPlaying,
                    onTap: () {
                      setState(() {
                        _controller!.value.isPlaying
                            ? _controller!.pause()
                            : _controller!.play();
                      });
                    },
                  ),
                if (_isInitialized && _controller != null)
                  VideoPlayerBottomControls(
                    controller: _controller!,
                    positionText: _formatDuration(_controller!.value.position),
                    durationText: _formatDuration(_controller!.value.duration),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
