import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/router/app_router.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/add_playlist_widget.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/playlist_card.dart';
import 'package:djsona_mobile/view/shared_components/popup_dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PlaylistsPage extends StatelessWidget {
  PlaylistsPage({super.key});
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();
  final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();

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
          child: _getContent(context, state),
        ),
      ),
    );
  }

  Widget _getAppBarContent(BuildContext context, AppState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _getAppBarTitles(context, state),
        _getNewPlaylistButton(context),
      ],
    );
  }

  Column _getAppBarTitles(BuildContext context, AppState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your playlists",
          style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: ColorConstants.white),
        ),
        Text(
          "${state.playlists.length} playlists",
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
          onPressed: () => showDialog(
            context: context,
            builder: (context) => PopupDialogLayout(
              title: Text(
                "New playlist",
                style: Theme.of(context).textTheme.heading5.copyWith(
                      color: ColorConstants.blackish,
                    ),
              ),
              body: AddPlaylistWidget(onCreatePressed: _appStateCubit.newPlaylist),
            ),
          ),
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
          splashRadius: AppBarWidget.leadingSize / 2,
        ),
      ),
    );
  }

  Widget _getContent(context, AppState state) {
    return ListView.builder(
      padding: StyleConstants.edgeInsetsT16,
      itemBuilder: ((context, index) {
        return Padding(
          padding: StyleConstants.edgeInsetsB16,
          child: PlaylistCard(
            playlist: state.playlists[index],
            isCurrentlyPlaying: audioService.queueTitle.value == state.playlists[index].name,
            onPressed: () => AutoRouter.of(context).push(
              PlaylistScreenRoute(playlistName: state.playlists[index].name),
            ),
            onDelete: () => _appStateCubit.deletePlaylist(state.playlists[index].name),
            isDisabled: state.playlists[index].songList.isEmpty,
          ),
        );
      }),
      itemCount: state.playlists.length,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }
}
