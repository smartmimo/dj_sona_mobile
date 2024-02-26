import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/song_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LikedSongsPage extends StatelessWidget {
  LikedSongsPage({super.key});
  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  @override
  Widget build(context) {
    return BlocBuilder<AppStateCubit, AppState>(
      bloc: _appStateCubit,
      builder: _mapStateToWidget,
    );
  }

  Widget _mapStateToWidget(BuildContext context, AppState state) {
    return Scaffold(
      backgroundColor: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(content: _getAppBarContent(context, state)),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dj_sona_icon.png"),
          ),
        ),
        child: Material(
          type: MaterialType.transparency,
          child: _getSongList(context, state),
        ),
      ),
    );
  }

  Widget _getSongList(BuildContext context, AppState state) {
    return StreamBuilder<MediaItem?>(
      stream: audioService.mediaItem,
      builder: (context, snapshot) {
        final MediaItem? currentlyPlaying = snapshot.data;
        return ListView.builder(
          padding: StyleConstants.edgeInsetsT16,
          itemBuilder: ((context, index) {
            return Padding(
              padding: StyleConstants.edgeInsetsB16,
              child: SongCard(
                songItem: state.likedSongs[index],
                isCurrentlyPlaying: currentlyPlaying?.id == state.likedSongs[index].id,
                isLoading: false,
                onPressed: () {},
              ),
            );
          }),
          itemCount: state.likedSongs.length,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      },
    );
  }

  Widget _getAppBarContent(BuildContext context, AppState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getAppBarTitles(context, state),
        _getAppBarActions(context, state),
      ],
    );
  }

  Column _getAppBarTitles(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Liked songs",
          style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: ColorConstants.white),
        ),
        Text(
          "${state.likedSongs.length} songs",
          style: Theme.of(context).textTheme.bodyLBold.copyWith(color: ColorConstants.paleGrey01),
        ),
      ].withVerticalElementsSpacing(4),
    );
  }

  Widget _getAppBarActions(BuildContext context, AppState state) {
    return Row(
      children: [
        _getDownloadButton(context, state),
        _getPlayButton(context),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getPlayButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: StyleConstants.radius100,
        boxShadow: StyleConstants.standardShadow,
      ),
      width: AppBarWidget.leadingSize,
      height: AppBarWidget.leadingSize,
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          icon: const Icon(
            Icons.play_arrow_rounded,
            size: AppBarWidget.leadingSize / 1.6,
            color: ColorConstants.white,
          ),
          onPressed: audioService.play,
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
          splashRadius: AppBarWidget.leadingSize / 2,
        ),
      ),
    );
  }

  Widget _getDownloadButton(BuildContext context, AppState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: StyleConstants.radius100,
        border: Border.all(
          color: ColorConstants.white,
          width: 2,
        ),
      ),
      width: AppBarWidget.leadingSize / 1.3,
      height: AppBarWidget.leadingSize / 1.3,
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          icon: const Icon(
            IconConstants.download,
            size: AppBarWidget.leadingSize / 2.08,
            color: ColorConstants.white,
          ),
          onPressed: () {},
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
          splashRadius: AppBarWidget.leadingSize / 2,
        ),
      ),
    );
  }
}
