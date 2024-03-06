import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/router/app_router.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/card_layout.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaylistsPage extends StatelessWidget {
  PlaylistsPage({super.key});
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();
  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(content: _getAppBarContent(context)),
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
          child: _getContent(context),
        ),
      ),
    );
  }

  Widget _getAppBarContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getAppBarTitles(context),
        _getNewPlaylistButton(context),
      ],
    );
  }

  Column _getAppBarTitles(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your playlists",
          style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: ColorConstants.white),
        ),
        Text(
          "${_appStateCubit.state.playlists.length} playlists",
          style: Theme.of(context).textTheme.bodyLBold.copyWith(color: ColorConstants.paleGrey01),
        ),
      ].withVerticalElementsSpacing(4),
    );
  }

  Widget _getNewPlaylistButton(BuildContext context) {
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
            IconConstants.plus,
            size: AppBarWidget.leadingSize / 1.6,
            color: ColorConstants.white,
          ),
          onPressed: () => {},
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
          splashRadius: AppBarWidget.leadingSize / 2,
        ),
      ),
    );
  }

  Widget _getContent(context) {
    return ListView.builder(
      padding: StyleConstants.edgeInsetsT16,
      itemBuilder: ((context, index) {
        return Padding(
          padding: StyleConstants.edgeInsetsB16,
          child: _getPlaylistCard(context, _appStateCubit.state.playlists[index]),
        );
      }),
      itemCount: _appStateCubit.state.playlists.length,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _getPlaylistCard(BuildContext context, Playlist playlist) {
    return CardLayout(
      padding: EdgeInsets.zero,
      hasBorder: audioService.queueTitle.value == playlist.name,
      content: InkWell(
        onTap: () => AutoRouter.of(context).push(PlaylistScreenRoute(playlistName: playlist.name)),
        child: Row(
          children: [
            _getThumbnailSection(context, playlist),
            _getPlaylistData(context, playlist),
          ],
        ),
      ),
    );
  }

  Widget _getThumbnailSection(BuildContext context, Playlist playlist) {
    return ClipRRect(
      borderRadius: StyleConstants.radiusTlBl8,
      child: Container(
        width: 100,
        height: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        child: Icon(
          IconConstants.playlist,
          size: 50,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _getPlaylistData(BuildContext context, Playlist playlist) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        color: audioService.queueTitle.value == playlist.name
            ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
            : null,
        padding: StyleConstants.edgeInsets8,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getPlaylistName(playlist, textTheme),
            _getPlaylistMetaData(playlist, textTheme),
          ].withVerticalElementsSpacing(8),
        ),
      ),
    );
  }

  Flexible _getPlaylistName(Playlist playlist, TextTheme textTheme) {
    return Flexible(
      child: Text(
        playlist.name,
        style: textTheme.bodyLBold.copyWith(color: ColorConstants.blackish),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _getPlaylistMetaData(Playlist playlist, TextTheme textTheme) {
    return Row(
      children: [
        _getPlaylistLength(playlist, textTheme),
        _getPlaylistCreationDate(playlist, textTheme),
      ]
          .withDivider(
            divider: const Icon(
              IconConstants.dash,
              color: ColorConstants.lightGrey,
            ),
            isLastDividerIncluded: false,
          )
          .withHorizontalElementsSpacing(8),
    );
  }

  Row _getPlaylistLength(Playlist playlist, TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          IconConstants.grid,
          size: 16,
          color: ColorConstants.lightGrey,
        ),
        Text(
          playlist.songList.isNotEmpty ? "${playlist.songList.length} songs" : "Empty",
          style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
        ),
      ].withHorizontalElementsSpacing(4),
    );
  }

  Row _getPlaylistCreationDate(Playlist playlist, TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          IconConstants.calendar,
          size: 16,
          color: ColorConstants.lightGrey,
        ),
        Text(
          DateFormat(AppConstants.dateFormatDots).format(playlist.creationDate),
          style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
        ),
      ].withHorizontalElementsSpacing(4),
    );
  }
}
