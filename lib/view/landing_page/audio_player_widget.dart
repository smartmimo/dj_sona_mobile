import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/landing_page/audio_player_opener.dart';
import 'package:djsona_mobile/view/landing_page/landing_page.dart';
import 'package:djsona_mobile/view/landing_page/seeker_widget.dart';
import 'package:djsona_mobile/view/shared_components/network_img.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee/marquee.dart';

class AudioPlayerWidget extends StatelessWidget {
  AudioPlayerWidget({super.key});

  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  static const double _miniWidgetImageWidth = 100;
  static const double _maxImageHeight = 150;
  static const double _heightToMini = 100;
  static const double _imageHeightOffset = 70;

  bool _isDragging(double currentHeight) =>
      currentHeight > LandingPage.bottomBarHeight && currentHeight < AudioPlayerOpener.openedBoxHeight;
  bool _isMiniWidget(double currentHeight) => currentHeight < _heightToMini;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MediaItem?>(stream: audioService.mediaItem, builder: _mapSnapshotToWidget);
  }

  Widget _mapSnapshotToWidget(BuildContext context, AsyncSnapshot<MediaItem?> snapshot) {
    final MediaItem? mediaItem = snapshot.data;
    if (mediaItem == null) return Container();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double currentHeight = constraints.maxHeight;
        return Container(
          height: LandingPage.bottomBarHeight,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: StyleConstants.radiusTlTr12,
          ),
          child: _getImageAndContent(
            context,
            MediaItemWrapper.fromMediaItem(mediaItem),
            currentHeight,
          ),
        );
      },
    );
  }

  Widget _getImageAndContent(
    BuildContext context,
    MediaItemWrapper mediaItem,
    double currentHeight,
  ) {
    return StreamBuilder<PlaybackState?>(
      stream: audioService.playbackState,
      builder: (context, snapshot) {
        final PlaybackState? state = snapshot.data;
        if (state == null) return Container();

        final bool isMiniWidget = _isMiniWidget(currentHeight);
        return Padding(
          padding: isMiniWidget ? EdgeInsets.zero : StyleConstants.edgeInsetsH16V8,
          child: Flex(
            direction: isMiniWidget ? Axis.horizontal : Axis.vertical,
            children: [
              if (!isMiniWidget) _getScrollerLineIcon(context),
              Stack(
                alignment: Alignment.center,
                fit: StackFit.passthrough,
                children: [
                  _getImage(mediaItem, currentHeight),
                  if (isMiniWidget) _getMiniPlayPauseButton(context, state),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: isMiniWidget ? StyleConstants.edgeInsets4 : EdgeInsets.zero,
                  child: _getPlayerContent(context, state, mediaItem, currentHeight),
                ),
              ),
            ].withVerticalElementsSpacing(8),
          ),
        );
      },
    );
  }

  ClipRRect _getImage(MediaItemWrapper mediaItem, double currentHeight) {
    final bool isMiniWidget = _isMiniWidget(currentHeight);
    return ClipRRect(
      borderRadius: isMiniWidget ? StyleConstants.radiusTl12 : StyleConstants.radius12,
      child: NetworkImg(
        mediaItem.artUri?.toString() ?? "",
        width: isMiniWidget && !_isDragging(currentHeight) ? _miniWidgetImageWidth : null,
        height: isMiniWidget
            ? currentHeight
            : currentHeight - _imageHeightOffset < _maxImageHeight
                ? currentHeight - _imageHeightOffset
                : _maxImageHeight,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _getMiniPlayPauseButton(BuildContext context, PlaybackState state) {
    final bool isPlaying = state.playing;
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.7),
          borderRadius: StyleConstants.radius100,
          border: Border.all(
            color: ColorConstants.white,
            width: 2,
          ),
        ),
        width: 30,
        height: 30,
        child: IconButton(
          icon: Icon(
            state.processingState == AudioProcessingState.completed
                ? Icons.replay_rounded
                : isPlaying
                    ? Icons.pause_rounded
                    : Icons.play_arrow_rounded,
            size: 20,
            color: ColorConstants.white,
          ),
          onPressed: state.processingState == AudioProcessingState.completed
              ? audioService.replay
              : isPlaying
                  ? audioService.pause
                  : audioService.play,
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.9),
        ),
      ),
    );
  }

  Widget _getPlayerContent(
    BuildContext context,
    PlaybackState state,
    MediaItemWrapper mediaItem,
    double currentHeight,
  ) {
    final bool isMiniWidget = _isMiniWidget(currentHeight);
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isMiniWidget) _getScrollerLineIcon(context),
        if (isMiniWidget || _isDragging(currentHeight)) ...{
          _getTitle(context, mediaItem, isMiniWidget),
        } else ...{
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _getTitle(context, mediaItem, isMiniWidget),
                _getSongActions(context, mediaItem),
              ].withHorizontalElementsSpacing(8),
            ),
          )
        },
        if (!isMiniWidget && !_isDragging(currentHeight)) _getPlayerActions(context, state, currentHeight),
        _getProgressSection(context, state, mediaItem, isMiniWidget),
      ].withVerticalElementsSpacing(isMiniWidget || _isDragging(currentHeight) ? 0 : 4),
    );
  }

  Container _getScrollerLineIcon(BuildContext context) {
    return Container(
      height: 3,
      width: 40,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _getTitle(BuildContext context, MediaItemWrapper mediaItem, bool isMiniWidget) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final TextStyle textStyle = isMiniWidget
        ? textTheme.bodyMBold.copyWith(color: ColorConstants.white)
        : textTheme.bodyLBold.copyWith(color: ColorConstants.white);

    final double widthOffset = isMiniWidget ? _miniWidgetImageWidth - 8 : (28 + 8) * 2 + 32;
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: mediaItem.title, style: textStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - widthOffset - 8);

    if (textPainter.didExceedMaxLines) {
      return Flexible(
        child: Marquee(
          textDirection: TextDirection.ltr,
          pauseAfterRound: const Duration(seconds: 2),
          text: mediaItem.title,
          style: textStyle,
          blankSpace: 40,
        ),
      );
    } else {
      return Text(mediaItem.title, style: textStyle);
    }
  }

  Widget _getProgressSection(BuildContext context, PlaybackState state, MediaItemWrapper mediaItem, bool isMiniWidget) {
    return SeekerWidget(
      seek: audioService.seek,
      totalDuration: mediaItem.duration!,
      currentDuration: state.position,
      bufferedDuration: state.bufferedPosition,
      seekerHeight: isMiniWidget ? 4 : 5,
    );
  }

  Widget _getPlayerActions(BuildContext context, PlaybackState state, double currentHeight) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _getShuffleButton(context, state),
        Row(
          children: [
            _getSwitchSongButton(context, iconData: IconConstants.previous, onPressed: audioService.skipToPrevious),
            _getPlayPauseButton(context, state),
            _getSwitchSongButton(context, iconData: IconConstants.next, onPressed: audioService.skipToNext),
          ].withHorizontalElementsSpacing(4),
        ),
        _getLoopButton(context, state),
      ],
    );
  }

  Widget _getPlayPauseButton(BuildContext context, PlaybackState state) {
    final bool isPlaying = state.playing;
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: StyleConstants.radius100,
          border: Border.all(
            color: Theme.of(context).colorScheme.secondary,
            width: 2,
          ),
        ),
        width: 52,
        height: 52,
        child: Material(
          type: MaterialType.transparency,
          shape: const CircleBorder(),
          clipBehavior: Clip.hardEdge,
          child: IconButton(
            icon: Icon(
              state.processingState == AudioProcessingState.completed
                  ? Icons.replay_rounded
                  : isPlaying
                      ? Icons.pause_rounded
                      : Icons.play_arrow_rounded,
              size: 32,
              color: Theme.of(context).colorScheme.primary,
            ),
            onPressed: state.processingState == AudioProcessingState.completed
                ? audioService.replay
                : isPlaying
                    ? audioService.pause
                    : audioService.play,
            padding: EdgeInsets.zero,
            splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            splashRadius: 1000,
          ),
        ),
      ),
    );
  }

  Widget _getSwitchSongButton(
    BuildContext context, {
    required IconData iconData,
    required VoidCallback onPressed,
  }) {
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        icon: Icon(
          iconData,
          size: 34,
          color: ColorConstants.white,
        ),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        splashRadius: 20,
      ),
    );
  }

  Widget _getShuffleButton(BuildContext context, PlaybackState state) {
    final bool isActivated = state.shuffleMode != AudioServiceShuffleMode.none;
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        icon: Icon(
          IconConstants.shuffle,
          size: 20,
          color: isActivated ? ColorConstants.greenSuccess : ColorConstants.white,
        ),
        onPressed: () => audioService.setShuffleMode(
          isActivated ? AudioServiceShuffleMode.none : AudioServiceShuffleMode.all,
        ),
        padding: EdgeInsets.zero,
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        splashRadius: 20,
      ),
    );
  }

  Widget _getLoopButton(BuildContext context, PlaybackState state) {
    final bool isActivated = state.repeatMode != AudioServiceRepeatMode.none;
    return Material(
      type: MaterialType.transparency,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: IconButton(
        icon: Icon(
          IconConstants.swap,
          size: 20,
          color: isActivated ? ColorConstants.greenSuccess : ColorConstants.white,
        ),
        onPressed: () => audioService.setRepeatMode(
          isActivated ? AudioServiceRepeatMode.none : AudioServiceRepeatMode.all,
        ),
        padding: EdgeInsets.zero,
        splashColor: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        splashRadius: 20,
      ),
    );
  }

  Widget _getSongActions(BuildContext context, MediaItemWrapper mediaItem) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _getSongActionIcon(context, iconData: IconConstants.addToPlaylist, onPressed: () {}),
        BlocBuilder<AppStateCubit, AppState>(
          bloc: _appStateCubit,
          builder: (context, state) {
            final bool isSongLiked = _appStateCubit.isSongLiked(SongItem.fromMediaItem(mediaItem));

            return _getSongActionIcon(
              context,
              iconData: isSongLiked ? IconConstants.heartFilled : IconConstants.heart,
              iconColor: isSongLiked ? ColorConstants.errorRed : null,
              onPressed: () => _appStateCubit.toggleSongLike(SongItem.fromMediaItem(mediaItem)),
            );
          },
        ),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getSongActionIcon(
    BuildContext context, {
    required IconData iconData,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: ColorConstants.white,
        borderRadius: StyleConstants.radius100,
        boxShadow: StyleConstants.standardShadow,
        border: Border.all(
            color: Theme.of(context).colorScheme.secondary, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          icon: Icon(
            iconData,
            size: 20,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
          ),
          splashColor: ColorConstants.blackish.withOpacity(0.4),
        ),
      ),
    );
  }
}
