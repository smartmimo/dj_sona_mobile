import 'dart:math';

import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/card_layout.dart';
import 'package:djsona_mobile/view/shared_components/delete_button.dart';
import 'package:djsona_mobile/view/shared_components/network_img.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PlaylistCard extends StatelessWidget {
  const PlaylistCard({
    super.key,
    required this.playlist,
    required this.isCurrentlyPlaying,
    required this.onPressed,
    this.onDelete,
    this.isDisabled = false,
  });

  final Playlist playlist;
  final bool isCurrentlyPlaying;
  final VoidCallback onPressed;
  final VoidCallback? onDelete;
  final bool isDisabled;

  static const double _defaultThumbnailSize = 50;
  static const double _miniDefaultThumbnailSize = 24;

  @override
  Widget build(BuildContext context) {
    return CardLayout(
      padding: EdgeInsets.zero,
      hasBorder: isCurrentlyPlaying,
      content: InkWell(
        borderRadius: StyleConstants.radius8,
        onTap: isDisabled ? null : onPressed,
        child: Row(
          children: [
            _getThumbnailSection(context),
            _getPlaylistData(context),
          ],
        ),
      ),
    );
  }

  Widget _getThumbnailSection(BuildContext context) {
    final List<String> images = List<String>.from(
      playlist.songList.map((e) => e.thumbnailUrl).whereType<String>(),
    );
    return ClipRRect(
      borderRadius: StyleConstants.radiusTlBl8,
      child: Container(
        width: 100,
        height: 100,
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        child: images.isEmpty ? _getDefaultThumbnail(context) : _getThumbnailSectionWithImages(context, images),
      ),
    );
  }

  Widget _getThumbnailSectionWithImages(BuildContext context, List<String> images) {
    images = images.length > 4 ? images.sublist(0, 4) : images;

    late final List<Widget> imageWidgets;
    if (images.length == 2) {
      imageWidgets = [
        NetworkImg(images[0]),
        _getDefaultThumbnail(context, size: _miniDefaultThumbnailSize),
        _getDefaultThumbnail(context, size: _miniDefaultThumbnailSize),
        NetworkImg(images[1]),
      ];
    } else if (images.length == 3) {
      imageWidgets = List<Widget>.from(images.map((e) => NetworkImg(e)))
        ..add(
          _getDefaultThumbnail(context, size: _miniDefaultThumbnailSize),
        );
    } else {
      imageWidgets = List<Widget>.from(images.map((e) => NetworkImg(e)));
    }
    return GridView.count(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: min(images.length, 2),
      children: imageWidgets,
    );
  }

  Widget _getDefaultThumbnail(BuildContext context, {double size = _defaultThumbnailSize}) {
    return Icon(
      IconConstants.playlist,
      size: size,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _getPlaylistData(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: ClipRRect(
        borderRadius: StyleConstants.radiusTrBr8,
        child: Container(
          color: isDisabled
              ? ColorConstants.paleGrey01
              : isCurrentlyPlaying
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                  : null,
          padding: StyleConstants.edgeInsets8,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _getPlaylistName(textTheme),
                    _getPlaylistMetaData(textTheme),
                  ].withVerticalElementsSpacing(8),
                ),
              ),
              _getActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Flexible _getPlaylistName(TextTheme textTheme) {
    return Flexible(
      child: Text(
        playlist.name,
        style: textTheme.bodyLBold.copyWith(color: ColorConstants.blackish),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _getPlaylistMetaData(TextTheme textTheme) {
    return Row(
      children: [
        _getPlaylistLength(textTheme),
        _getPlaylistCreationDate(textTheme),
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

  Row _getPlaylistLength(TextTheme textTheme) {
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

  Row _getPlaylistCreationDate(TextTheme textTheme) {
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

  Widget _getActions(BuildContext context) {
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
