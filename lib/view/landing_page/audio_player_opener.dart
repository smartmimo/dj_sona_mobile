import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/view/landing_page/landing_page.dart';
import 'package:djsona_mobile/view/landing_page/audio_player_widget.dart';
import 'package:flutter/material.dart' hide SearchBar;

class AudioPlayerOpener extends StatefulWidget {
  AudioPlayerOpener({
    super.key,
  });

  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();

  static const double defaultBoxHeight = LandingPage.bottomBarHeight;
  static const double openedBoxHeight = 300;

  @override
  State<AudioPlayerOpener> createState() => _AudioPlayerOpenerState();
}

class _AudioPlayerOpenerState extends State<AudioPlayerOpener> {
  static const double _heightToTriggerOpen = 200;
  static const Duration _animationDuration = Duration(milliseconds: 300);

  MediaItem? _mediaItem;
  PlaybackState? _playbackState;
  double _boxHeight = 0;
  bool _isBarDragging = false;

  @override
  void initState() {
    widget.audioService.mediaItem.stream.listen((mediaItem) {
      setState(() => _mediaItem = mediaItem);
    });

    widget.audioService.playbackState.stream.listen((state) {
      setState(() => _playbackState = state);
    });

    _boxHeight = AudioPlayerOpener.defaultBoxHeight;
    super.initState();
  }

  void _onVerticalDragUpdate(DragUpdateDetails details) {
    final double distanceScrolled = details.delta.dy;
    final bool isOverFlowDown = _boxHeight - distanceScrolled < AudioPlayerOpener.defaultBoxHeight;

    if (isOverFlowDown) return;

    setState(() {
      _boxHeight -= distanceScrolled;
      if (_boxHeight > _heightToTriggerOpen) _openAudioPlayer(context);
    });
  }

  void _onVerticalDragEnd(DragEndDetails details) {
    if (_boxHeight > _heightToTriggerOpen) return;
    setState(() {
      _isBarDragging = false;
      _boxHeight = AudioPlayerOpener.defaultBoxHeight;
    });
  }

  void _onVerticalDragStart(DragStartDetails _) {
    if (_boxHeight > _heightToTriggerOpen) {
      _closeAudioPlayer(context);
    } else {
      setState(() {
        _isBarDragging = true;
      });
    }
  }

  void _triggerShakeAnimation() {
    setState(() {
      _boxHeight += 20;
    });
    Future.delayed(
      _animationDuration,
      () => setState(() {
        _boxHeight = AudioPlayerOpener.defaultBoxHeight;
      }),
    );
  }

  _openAudioPlayer(BuildContext context) {
    setState(() {
      _isBarDragging = false;
      _boxHeight = AudioPlayerOpener.openedBoxHeight;
    });
  }

  _closeAudioPlayer(BuildContext context) {
    setState(() {
      _boxHeight = AudioPlayerOpener.defaultBoxHeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: _onVerticalDragUpdate,
      onVerticalDragEnd: _onVerticalDragEnd,
      onVerticalDragStart: _onVerticalDragStart,
      onTap: _triggerShakeAnimation,
      child: _getAnimatedWidget(context),
    );
  }

  Widget _getAnimatedWidget(BuildContext context) {
    final bool isHidden = _playbackState == null || _mediaItem == null;
    return AnimatedContainer(
      duration: !_isBarDragging ? _animationDuration : const Duration(milliseconds: 0),
      height: isHidden ? 0 : _boxHeight,
      curve: Curves.easeInOut,
      child: isHidden
          ? Container()
          : AudioPlayerWidget(
              state: _playbackState!,
              mediaItem: _mediaItem!,
            ),
    );
  }
}
