import 'package:guard_well/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Top bar with title and close action for the fullscreen video player.
class VideoPlayerTopBar extends StatelessWidget {
  final String title;

  const VideoPlayerTopBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// Center Play/Pause toggle overlay button.
class VideoPlayerCenterPlayButton extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onTap;

  const VideoPlayerCenterPlayButton({
    super.key,
    required this.isPlaying,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black.withValues(alpha: 0.6),
          ),
          child: Icon(
            isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 44,
          ),
        ),
      ),
    );
  }
}

/// Bottom scrubber progress indicator and elapsed/total duration labels.
class VideoPlayerBottomControls extends StatelessWidget {
  final VideoPlayerController controller;
  final String positionText;
  final String durationText;

  const VideoPlayerBottomControls({
    super.key,
    required this.controller,
    required this.positionText,
    required this.durationText,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withValues(alpha: 0.8),
              Colors.transparent,
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              colors: const VideoProgressColors(
                playedColor: AppColors.appPrimaryColor,
                bufferedColor: Color(0x66FFFFFF),
                backgroundColor: Color(0x33FFFFFF),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  positionText,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  durationText,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Error view with retry callback.
class VideoPlayerErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const VideoPlayerErrorView({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, color: AppColors.red, size: 40),
        const SizedBox(height: 12),
        const Text(
          'Could not load video',
          style: TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: onRetry,
          child: const Text('Retry', style: TextStyle(color: Colors.white70)),
        ),
      ],
    );
  }
}
