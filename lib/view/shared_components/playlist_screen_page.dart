import 'package:audio_service/audio_service.dart';
import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/download_indicator.dart';
import 'package:djsona_mobile/view/shared_components/loading_widget.dart';
import 'package:djsona_mobile/view/shared_components/song_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistScreenPage extends StatelessWidget {
  PlaylistScreenPage({
    super.key,
    required this.playlistName,
  });
  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  final String playlistName;

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
      appBar: AppBarWidget(
        content: _getAppBarContent(context, state),
        leading: _getAppBarLeading(context),
      ),
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
    final List<SongItem> songList = _appStateCubit.getPlaylistSongs(playlistName: playlistName);

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
                songItem: songList[index],
                isCurrentlyPlaying:
                    audioService.queueTitle.value == playlistName && currentlyPlaying?.id == songList[index].id,
                isLoading: false,
                onPressed: state.playlistLoadingName == playlistName
                    ? null
                    : () => _appStateCubit.startPlaylist(
                          playlistName: playlistName,
                          startAt: index,
                        ),
              ),
            );
          }),
          itemCount: songList.length,
          physics: const AlwaysScrollableScrollPhysics(),
        );
      },
    );
  }

  Widget? _getAppBarLeading(BuildContext context) {
    if (playlistName == AppConstants.likedSongsPlaylistName) {
      return null;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Ink(
          width: AppBarWidget.leadingSize,
          height: AppBarWidget.leadingSize,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
            boxShadow: StyleConstants.standardShadow,
            borderRadius: StyleConstants.radius12,
          ),
          child: InkWell(
            borderRadius: StyleConstants.radius12,
            onTap: AutoRouter.of(context).pop,
            splashColor: Theme.of(context).colorScheme.secondary,
            child: const Icon(
              IconConstants.chevronLeft,
              color: ColorConstants.white,
            ),
          ),
        ),
      ],
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
    final List<SongItem> songList = _appStateCubit.getPlaylistSongs(playlistName: playlistName);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          playlistName,
          style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: ColorConstants.white),
        ),
        Text(
          "${songList.length} songs",
          style: Theme.of(context).textTheme.bodyLBold.copyWith(color: ColorConstants.paleGrey01),
        ),
      ].withVerticalElementsSpacing(4),
    );
  }

  Widget _getAppBarActions(BuildContext context, AppState state) {
    return Row(
      children: [
        _getDownloadButton(context, state),
        _getPlayButton(context, state),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getPlayButton(BuildContext context, AppState state) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
        borderRadius: StyleConstants.radius100,
        boxShadow: StyleConstants.standardShadow,
      ),
      width: AppBarWidget.leadingSize,
      height: AppBarWidget.leadingSize,
      child: state.playlistLoadingName == playlistName
          ? const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: LoadingWidget(color: ColorConstants.white),
              ),
            )
          : Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: IconButton(
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  size: AppBarWidget.leadingSize / 1.6,
                  color: ColorConstants.white,
                ),
                onPressed: () => _appStateCubit.startPlaylist(playlistName: playlistName),
                padding: EdgeInsets.zero,
                splashColor: Theme.of(context).colorScheme.secondary,
                splashRadius: AppBarWidget.leadingSize / 2,
              ),
            ),
    );
  }

  Widget _getDownloadButton(BuildContext context, AppState state) {
    final Playlist? playlist = state.getPlaylistByName(playlistName);
    if (playlist == null) return Container();

    return DownloadIndicator(playlist: playlist, size: AppBarWidget.leadingSize);
  }
}
