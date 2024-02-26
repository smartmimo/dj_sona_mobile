import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/view/landing_page/landing_page.dart';
import 'package:djsona_mobile/view/landing_page/audio_player_widget.dart';
import 'package:flutter/material.dart' hide SearchBar;

class AudioPlayerOpener extends StatefulWidget {
  const AudioPlayerOpener({super.key});

  static const double defaultBoxHeight = LandingPage.bottomBarHeight;
  static const double openedBoxHeight = 300;

  @override
  State<AudioPlayerOpener> createState() => _AudioPlayerOpenerState();
}

class _AudioPlayerOpenerState extends State<AudioPlayerOpener> {
  static const double _heightToTriggerOpen = 200;
  static const Duration _animationDuration = Duration(milliseconds: 700);
  static const Duration _initialAnimationDuration = Duration(milliseconds: 2000);

  double _boxHeight = 0;
  bool _isBarDragging = false;

  @override
  void initState() {
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
      child: StreamBuilder<MediaItem?>(
        stream: serviceLocator.get<AudioPlayerService>().mediaItem,
        builder: _mapSnapshotToWidget,
      ),
    );
  }

  Widget _mapSnapshotToWidget(BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
    return AnimatedContainer(
      duration: _boxHeight < AudioPlayerOpener.defaultBoxHeight
          ? _initialAnimationDuration
          : !_isBarDragging
              ? _animationDuration
              : const Duration(milliseconds: 0),
      height: snapshot.data != null ? _boxHeight : 0,
      curve: _boxHeight < AudioPlayerOpener.defaultBoxHeight ? Curves.easeInOut : Curves.bounceOut,
      child: AudioPlayerWidget(),
    );
  }
}
