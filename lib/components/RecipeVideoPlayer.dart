import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:fondia/utils/recipe_image.dart';

enum _PlayerPhase { idle, loading, ready, playing, error }

/// 菜谱详情页视频播放器
class RecipeVideoPlayer extends StatefulWidget {
  final String? playUrl;
  final String? coverImage;
  final VoidCallback? onBack;
  final Widget? topActions;
  final Widget? sideActions;

  const RecipeVideoPlayer({
    super.key,
    required this.playUrl,
    this.coverImage,
    this.onBack,
    this.topActions,
    this.sideActions,
  });

  @override
  State<RecipeVideoPlayer> createState() => _RecipeVideoPlayerState();
}

class _RecipeVideoPlayerState extends State<RecipeVideoPlayer> {
  VideoPlayerController? _controller;
  _PlayerPhase _phase = _PlayerPhase.idle;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _preparePlayer();
  }

  @override
  void didUpdateWidget(covariant RecipeVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.playUrl != widget.playUrl) {
      _disposePlayer();
      _preparePlayer();
    }
  }

  void _onControllerUpdate() {
    final controller = _controller;
    if (controller == null || !mounted) return;
    if (controller.value.hasError) {
      setState(() {
        _phase = _PlayerPhase.error;
        _errorMessage = controller.value.errorDescription ?? '视频播放失败';
      });
      return;
    }
    if (controller.value.isPlaying && _phase != _PlayerPhase.playing) {
      setState(() => _phase = _PlayerPhase.playing);
    } else if (!controller.value.isPlaying && _phase == _PlayerPhase.playing) {
      setState(() => _phase = _PlayerPhase.ready);
    }
  }

  Future<void> _preparePlayer() async {
    final url = widget.playUrl?.trim();
    if (url == null || url.isEmpty) {
      setState(() {
        _phase = _PlayerPhase.idle;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _phase = _PlayerPhase.loading;
      _errorMessage = null;
    });

    final controller = VideoPlayerController.networkUrl(
      Uri.parse(url),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );
    _controller = controller;
    controller.addListener(_onControllerUpdate);

    try {
      await controller.initialize();
      await controller.setLooping(false);
      await controller.setVolume(1);
      // 部分平台需先 play 再 pause 才会渲染首帧
      await controller.play();
      await controller.pause();
      await controller.seekTo(Duration.zero);
      if (!mounted) return;
      setState(() => _phase = _PlayerPhase.ready);
    } catch (error, stack) {
      debugPrint('RecipeVideoPlayer init failed: $error\n$stack');
      if (!mounted) return;
      setState(() {
        _phase = _PlayerPhase.error;
        _errorMessage = '视频加载失败，请稍后重试';
      });
    }
  }

  Future<void> _togglePlay() async {
    if (_phase == _PlayerPhase.error) {
      await _preparePlayer();
      return;
    }
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    if (controller.value.isPlaying) {
      await controller.pause();
      if (mounted) setState(() => _phase = _PlayerPhase.ready);
    } else {
      await controller.play();
      if (mounted) setState(() => _phase = _PlayerPhase.playing);
    }
  }

  void _disposePlayer() {
    _controller?.removeListener(_onControllerUpdate);
    _controller?.dispose();
    _controller = null;
    _phase = _PlayerPhase.idle;
    _errorMessage = null;
  }

  @override
  void dispose() {
    _disposePlayer();
    super.dispose();
  }

  bool get _showVideo {
    final controller = _controller;
    return controller != null &&
        controller.value.isInitialized &&
        _phase != _PlayerPhase.error &&
        _phase != _PlayerPhase.loading;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = width * 10 / 16;
    final controller = _controller;

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_showVideo && controller != null)
            Center(
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio == 0
                    ? 16 / 9
                    : controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            )
          else
            RecipeImage(
              url: widget.coverImage,
              fit: BoxFit.cover,
              width: width,
              height: height,
            ),
          if (_phase == _PlayerPhase.loading)
            Container(
              color: Colors.black.withValues(alpha: 0.25),
              alignment: Alignment.center,
              child: const CircularProgressIndicator(color: Colors.white),
            ),
          if (_phase == _PlayerPhase.error)
            Container(
              color: Colors.black.withValues(alpha: 0.45),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _errorMessage ?? '视频无法播放',
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: _preparePlayer,
                    child: const Text('点击重试', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          if (_phase == _PlayerPhase.ready || _phase == _PlayerPhase.playing)
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _togglePlay,
                child: AnimatedOpacity(
                  opacity: _phase == _PlayerPhase.playing ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.12),
                    alignment: Alignment.center,
                    child: IconButton(
                      iconSize: 64,
                      color: Colors.white,
                      icon: Icon(
                        _phase == _PlayerPhase.playing
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                      ),
                      onPressed: _togglePlay,
                    ),
                  ),
                ),
              ),
            )
          else if (widget.playUrl != null &&
              widget.playUrl!.isNotEmpty &&
              _phase == _PlayerPhase.idle)
            Center(
              child: IconButton(
                iconSize: 64,
                color: Colors.white,
                icon: const Icon(Icons.play_circle_fill),
                onPressed: _preparePlayer,
              ),
            ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 8,
            right: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  onPressed: widget.onBack ?? () => Navigator.pop(context),
                ),
                if (widget.topActions != null) widget.topActions!,
              ],
            ),
          ),
          if (widget.sideActions != null)
            Positioned(
              right: 16,
              top: height * 0.35,
              child: widget.sideActions!,
            ),
        ],
      ),
    );
  }
}
