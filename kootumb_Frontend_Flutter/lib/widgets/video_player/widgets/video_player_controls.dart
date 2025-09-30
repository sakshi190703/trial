import 'dart:async';

import 'package:Kootumb/models/theme.dart';
import 'package:Kootumb/provider.dart';
import 'package:Kootumb/widgets/progress_indicator.dart';
import 'package:Kootumb/widgets/video_player/widgets/chewie/chewie_player.dart';
import 'package:Kootumb/widgets/video_player/widgets/chewie/chewie_progress_colors.dart';
import 'package:Kootumb/widgets/video_player/widgets/chewie/material_progress_bar.dart';
import 'package:Kootumb/widgets/video_player/widgets/chewie/utils.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../icon.dart';

class OBVideoPlayerControls extends StatefulWidget {
  final Function(Function)? onExpandCollapse;
  final Function(Function)? onPause;
  final Function(Function)? onPlay;
  final Function(Function)? onMute;
  final Function(Function)? onUnmute;
  final OBVideoPlayerControlsController? controller;

  const OBVideoPlayerControls(
      {Key? key,
      this.onExpandCollapse,
      this.controller,
      this.onMute,
      this.onUnmute,
      this.onPause,
      this.onPlay})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OBVideoPlayerControlsState();
  }
}

class OBVideoPlayerControlsState extends State<OBVideoPlayerControls> {
  VideoPlayerValue? _latestValue;
  double? _latestVolume;
  bool _hideStuff = true;
  Timer? _hideTimer;
  Timer? _initTimer;
  Timer? _showAfterExpandCollapseTimer;
  bool _dragging = false;
  bool? _isDismissable;

  final barHeight = 48.0;
  final marginSize = 5.0;

  VideoPlayerController? controller;
  ChewieController? chewieController;

  @override
  Widget build(BuildContext context) {
    Widget mainWidget;

    bool isLoading = _latestValue != null &&
            !_latestValue!.isPlaying &&
            _latestValue!.duration == null ||
        _latestValue != null && _latestValue!.isBuffering;

    bool hasError = _latestValue != null && _latestValue!.hasError;

    if (isLoading) {
      mainWidget = Expanded(
        child: Center(
          child: OBProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    } else if (hasError) {
      mainWidget = chewieController?.errorBuilder != null
          ? chewieController!.errorBuilder!(
              context,
              chewieController!.videoPlayerController.value.errorDescription ??
                  '',
            )
          : Center(
              child: OBIcon(
                OBIcons.error,
                color: Colors.white,
                customSize: 42,
              ),
            );
    } else {
      mainWidget = _buildHitArea();
    }

    return Stack(children: <Widget>[
      AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          color: Colors.black38,
        ),
      ),
      Column(
        children: <Widget>[
          mainWidget,
          _buildBottomBar(context, controller!),
        ],
      ),
      _hideStuff || _isDismissable == null || !_isDismissable!
          ? Container()
          : IconButton(
              icon: OBIcon(
                OBIcons.close,
                color: Colors.white,
              ),
              onPressed: () async {
                print("pressed true");
                controller!.pause();
                Navigator.pop(context);
              },
            ),
    ]);
  }

  @override
  void initState() {
    super.initState();
    _isDismissable = false;
    if (widget.controller != null) widget.controller!.attach(this);
  }

  @override
  void dispose() {
    _dispose();
    super.dispose();
  }

  void _dispose() {
    controller!.removeListener(_updateState);
    _hideTimer?.cancel();
    _initTimer?.cancel();
    _showAfterExpandCollapseTimer?.cancel();
  }

  @override
  void didChangeDependencies() {
    final oldController = chewieController;
    chewieController = ChewieController.of(context);
    controller = chewieController!.videoPlayerController;

    if (oldController != chewieController) {
      _dispose();
      _initialize();
    }

    super.didChangeDependencies();
  }

  AnimatedOpacity _buildBottomBar(
    BuildContext context,
    VideoPlayerController controller,
  ) {
    return AnimatedOpacity(
      opacity: _hideStuff ? 0.0 : 1.0,
      duration: Duration(milliseconds: 300),
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        child: Row(
          children: <Widget>[
            _buildPlayPause(controller),
            _buildPosition(Colors.white),
            _buildProgressBar(),
            _buildMuteButton(controller),
            chewieController!.allowFullScreen
                ? _buildExpandButton()
                : const SizedBox(),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildExpandButton() {
    return GestureDetector(
      onTap: widget.onExpandCollapse != null
          ? () {
              widget.onExpandCollapse!(_onExpandCollapse);
            }
          : _onExpandCollapse,
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: Container(
          height: barHeight,
          margin: EdgeInsets.only(right: 12.0),
          padding: EdgeInsets.only(
            left: 8.0,
            right: 8.0,
          ),
          child: Center(
            child: OBIcon(
              chewieController!.isFullScreen
                  ? OBIcons.fullscreen_exit
                  : OBIcons.fullscreen,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Expanded _buildHitArea() {
    return Expanded(
      child: GestureDetector(
        onTap: _latestValue != null && _latestValue!.isPlaying
            ? () {
                _playPause();
                //_cancelAndRestartTimer;
                setState(() {
                  _hideStuff = false;
                });
              }
            : () {
                _playPause();
                setState(() {
                  _hideStuff = true;
                });
              },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: AnimatedOpacity(
              opacity:
                  _latestValue != null && !_latestValue!.isPlaying && !_dragging
                      ? 1.0
                      : 0.0,
              duration: Duration(milliseconds: 300),
              child: GestureDetector(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(48.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 30.0),
                    child: OBIcon(
                      OBIcons.play_arrow,
                      customSize: 50.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _buildMuteButton(
    VideoPlayerController controller,
  ) {
    return GestureDetector(
      onTap: () {
        _cancelAndRestartTimer();

        if (_latestValue?.volume == 0) {
          if (widget.onUnmute != null) {
            widget.onUnmute!(_unMute);
          } else {
            _unMute();
          }
        } else {
          if (widget.onMute != null) {
            widget.onMute!(_mute);
          } else {
            _mute();
          }
        }
      },
      child: AnimatedOpacity(
        opacity: _hideStuff ? 0.0 : 1.0,
        duration: Duration(milliseconds: 300),
        child: ClipRect(
          child: Container(
            child: Container(
              height: barHeight,
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: OBIcon(
                (_latestValue != null && _latestValue!.volume > 0)
                    ? OBIcons.volume_up
                    : OBIcons.volume_off,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _mute() {
    _latestVolume = controller!.value.volume;
    controller!.setVolume(0.0);
  }

  void _unMute() {
    controller!.setVolume(_latestVolume ?? 0.5);
  }

  GestureDetector _buildPlayPause(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _playPause,
      child: Container(
        height: barHeight,
        color: Colors.transparent,
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
      ),
    );
  }

  Widget _buildPosition(Color iconColor) {
    final position =
        _latestValue != null ? _latestValue!.position : Duration.zero;
    final duration =
        _latestValue != null ? _latestValue!.duration : Duration.zero;

    return Padding(
      padding: EdgeInsets.only(right: 24.0),
      child: Text(
        '${formatDuration(position)} / ${formatDuration(duration)}',
        style: TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
      ),
    );
  }

  void _cancelAndRestartTimer() {
    _hideTimer?.cancel();
    _startHideTimer();

    setState(() {
      _hideStuff = false;
    });
  }

  Future<Null> _initialize() async {
    controller?.addListener(_updateState);

    _updateState();

    if ((controller?.value != null && controller!.value.isPlaying) ||
        chewieController!.autoPlay) {
      _startHideTimer();
    }

    if (chewieController!.showControlsOnInitialize) {
      _initTimer = Timer(Duration(milliseconds: 200), () {
        setState(() {
          _hideStuff = false;
        });
      });
    }
  }

  void _onExpandCollapse() {
    setState(() {
      _hideStuff = true;

      chewieController!.toggleFullScreen();
      _showAfterExpandCollapseTimer = Timer(Duration(milliseconds: 300), () {
        setState(() {
          _cancelAndRestartTimer();
        });
      });
    });
  }

  void _playPause() {
    setState(() {
      if (controller!.value.isPlaying) {
        if (widget.onPause != null) {
          widget.onPause!(_pause);
        } else {
          _pause();
        }
      } else {
        if (widget.onPlay != null) {
          widget.onPlay!(_play);
        } else {
          _play();
        }
      }
    });
  }

  void _pause() {
    _hideStuff = false;
    _hideTimer?.cancel();
    controller!.pause();
  }

  void _play() {
    _cancelAndRestartTimer();

    // if (!controller!.value.initialized) {
    //   controller!.initialize().then((_) {
    //     controller!.play();
    //   });
    // } else {
    controller!.play();
    // }
  }

  void _startHideTimer() {
    _hideTimer = Timer(const Duration(seconds: 3), () {
      setState(() {
        _hideStuff = true;
      });
    });
  }

  void _updateState() {
    setState(() {
      _latestValue = controller!.value;
    });
  }

  void setIsDismissible(bool isDismissible) {
    debugLog('Setting isDismissible to ${isDismissible.toString()}');

    setState(() {
      _isDismissable = isDismissible;
    });
  }

  Widget _buildProgressBar() {
    KongoProviderState kongoProvider = KongoProvider.of(context);
    OBTheme activeTheme = kongoProvider.themeService.getActiveTheme();

    Color actionsForegroundColor = kongoProvider.themeValueParserService
        .parseGradient(activeTheme.primaryAccentColor)
        .colors[1];

    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(right: 20.0),
        child: MaterialVideoProgressBar(
          controller!,
          onDragStart: () {
            setState(() {
              _dragging = true;
            });

            _hideTimer?.cancel();
          },
          onDragEnd: () {
            setState(() {
              _dragging = false;
            });

            _startHideTimer();
          },
          colors: ChewieProgressColors(
              playedColor: actionsForegroundColor,
              handleColor: actionsForegroundColor,
              bufferedColor: Colors.grey,
              backgroundColor: Colors.grey),
        ),
      ),
    );
  }

  void debugLog(String log) {
    debugPrint('OBVideoPlayerControls:$log');
  }
}

class OBVideoPlayerControlsController {
  late OBVideoPlayerControlsState _state;

  OBVideoPlayerControlsController();

  void attach(state) {
    _state = state;
  }

  void setIsDismissible(bool isDismissible) {
    _state.setIsDismissible(isDismissible);
  }

  void pop() {
    Navigator.of(_state.context).pop();
  }
}
