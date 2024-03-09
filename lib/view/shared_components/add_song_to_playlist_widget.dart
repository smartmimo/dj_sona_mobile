import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/add_playlist_widget.dart';
import 'package:djsona_mobile/view/shared_components/button_master.dart';
import 'package:djsona_mobile/view/shared_components/playlist_card.dart';
import 'package:djsona_mobile/view/shared_components/popup_dialog_layout.dart';
import 'package:djsona_mobile/view/shared_components/snack_bar_widget.dart';
import 'package:flutter/material.dart';

class AddSongToPlaylist extends StatelessWidget {
  AddSongToPlaylist({
    super.key,
    required this.songItem,
  });

  final SongItem songItem;
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    if (_appStateCubit.state.playlists.isEmpty) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Icon(
                IconConstants.info,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                "No playlists were found",
                style: textTheme.heading3.copyWith(color: Theme.of(context).colorScheme.primary),
              ),
            ].withVerticalElementsSpacing(12),
          ),
          _newPlaylistButton(context),
        ].withVerticalElementsSpacing(48),
      );
    } else {
      return Column(
        children: [
          Expanded(child: _getPlaylistList(context)),
          _newPlaylistButton(context),
        ],
      );
    }
  }

  Widget _getPlaylistList(BuildContext context) {
    return ListView.builder(
      padding: StyleConstants.edgeInsetsT16,
      itemBuilder: ((context, index) {
        return Padding(
          padding: StyleConstants.edgeInsetsB16,
          child: PlaylistCard(
            playlist: _appStateCubit.state.playlists[index],
            isCurrentlyPlaying: false,
            onPressed: () {},
          ),
        );
      }),
      itemCount: _appStateCubit.state.playlists.length,
      physics: const AlwaysScrollableScrollPhysics(),
    );
  }

  Widget _newPlaylistButton(BuildContext context) {
    return ButtonMaster(
      text: "Add to a new playlist",
      onPressed: () {
        showDialog<Playlist>(
          context: context,
          builder: (_) => PopupDialogLayout(
            title: Text(
              "New playlist",
              style: Theme.of(context).textTheme.heading5.copyWith(
                    color: ColorConstants.blackish,
                  ),
            ),
            body: Material(child: AddPlaylistWidget(onCreatePressed: _appStateCubit.newPlaylist)),
          ),
        ).then((result) {
          if (result != null) {
            _onSongAdded(context, result);
          }
        });
      },
    );
  }

  void _onSongAdded(BuildContext context, Playlist result) {
    _appStateCubit.addItemToPlaylist(playlistName: result.name, item: songItem);
    AutoRouter.of(context).pop();
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBarWidget.success(
          context: context,
          text: "Song added to playlist",
        ),
      );
  }
}
