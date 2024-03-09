import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/card_layout.dart';
import 'package:djsona_mobile/view/shared_components/delete_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.isCurrentlyPlaying,
    required this.onPressed,
    this.onDelete,
  });

  final Playlist playlist;
  final bool isCurrentlyPlaying;
  final VoidCallback onPressed;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return CardLayout(
      padding: EdgeInsets.zero,
      hasBorder: isCurrentlyPlaying,
      content: InkWell(
        borderRadius: StyleConstants.radius8,
        onTap: onPressed,
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
        color: isCurrentlyPlaying ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
        padding: StyleConstants.edgeInsets8,
        height: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _getPlaylistName(playlist, textTheme),
                  _getPlaylistMetaData(playlist, textTheme),
                ].withVerticalElementsSpacing(8),
              ),
            ),
            _getActions(context, playlist),
          ],
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

  Widget _getActions(BuildContext context, Playlist playlist) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onDelete != null) ...{
          DeleteButton(
            isDisabled: false,
            onPressed: onDelete!,
            onlyIcon: true,
          ),
        }
      ],
    );
  }
}
