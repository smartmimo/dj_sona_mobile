import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/add_song_to_playlist_widget.dart';
import 'package:djsona_mobile/view/shared_components/card_layout.dart';
import 'package:djsona_mobile/view/shared_components/loading_widget.dart';
import 'package:djsona_mobile/view/shared_components/network_img.dart';
import 'package:djsona_mobile/view/shared_components/popup_dialog_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SongCard extends StatelessWidget {
  SongCard({
    super.key,
    required this.songItem,
    required this.isCurrentlyPlaying,
    required this.isLoading,
    required this.onPressed,
  });
  final SongItem songItem;
  final bool isCurrentlyPlaying;
  final bool isLoading;
  final VoidCallback? onPressed;

  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  @override
  Widget build(BuildContext context) {
    return CardLayout(
      padding: EdgeInsets.zero,
      hasBorder: isCurrentlyPlaying,
      content: InkWell(
        onTap: onPressed,
        child: Row(
          children: [
            _getThumbnailSection(context),
            _getSongData(context),
          ],
        ),
      ),
    );
  }

  Widget _getThumbnailSection(BuildContext context) {
    return Stack(
      children: [
        _getImage(),
        if (StringUtils.isNotEmpty(songItem.durationString)) ...{
          _getDurationWidget(context),
        },
      ],
    );
  }

  ClipRRect _getImage() {
    return ClipRRect(
      borderRadius: StyleConstants.radiusTlBl8,
      child: NetworkImg(songItem.thumbnailUrl, width: 130, height: 100, fit: BoxFit.cover),
    );
  }

  Widget _getDurationWidget(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Positioned(
      bottom: 8,
      right: 8,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstants.white,
          borderRadius: StyleConstants.radius4,
          boxShadow: StyleConstants.standardShadow,
        ),
        padding: StyleConstants.edgeInsetsH4V2,
        child: Text(
          songItem.durationString!,
          style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
        ),
      ),
    );
  }

  Widget _getSongData(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Container(
        color: isCurrentlyPlaying ? Theme.of(context).colorScheme.primary.withOpacity(0.2) : null,
        padding: StyleConstants.edgeInsets8,
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _getSongTitle(textTheme),
            _getSongMetaData(textTheme),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: LoadingWidget(),
                      )
                    : Container(),
                _getSongActions(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Flexible _getSongTitle(TextTheme textTheme) {
    return Flexible(
      child: Text(
        songItem.title,
        style: textTheme.bodyLBold.copyWith(color: ColorConstants.blackish),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _getSongMetaData(TextTheme textTheme) {
    return Row(
      children: [
        if (StringUtils.isNotEmpty(songItem.viewsString)) ...{
          _getSongViews(textTheme),
        },
        if (StringUtils.isNotEmpty(songItem.publishedTimeString)) ...{
          Flexible(
            child: _getSongPublishTime(textTheme),
          ),
        },
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

  Widget _getSongViews(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          IconConstants.eye,
          size: 16,
          color: ColorConstants.lightGrey,
        ),
        Text(
          songItem.viewsString!,
          style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
        ),
      ].withHorizontalElementsSpacing(4),
    );
  }

  Widget _getSongPublishTime(TextTheme textTheme) {
    return Row(
      children: [
        const Icon(
          IconConstants.calendar,
          size: 16,
          color: ColorConstants.lightGrey,
        ),
        Flexible(
          child: Text(
            songItem.publishedTimeString!,
            style: textTheme.bodyMBold.copyWith(color: ColorConstants.lightGrey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ].withHorizontalElementsSpacing(4),
    );
  }

  Widget _getSongActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _getActionIcon(
          context,
          iconData: IconConstants.addToPlaylist,
          onPressed: () => showDialog(
            context: context,
            builder: (context) => GestureDetector(
              onTap: AutoRouter.of(context).pop,
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                  onTap: () {},
                  child: PopupDialogLayout(
                    title: Text(
                      "Add song to playlist",
                      style: Theme.of(context).textTheme.heading5,
                    ),
                    body: AddSongToPlaylist(
                      songItem: songItem,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        BlocBuilder<AppStateCubit, AppState>(
          bloc: _appStateCubit,
          builder: (context, state) {
            final bool isSongLiked = _appStateCubit.isSongLiked(songItem);

            return _getActionIcon(
              context,
              iconData: isSongLiked ? IconConstants.heartFilled : IconConstants.heart,
              iconColor: isSongLiked ? ColorConstants.errorRed : null,
              onPressed: () => _appStateCubit.toggleSongLike(songItem),
            );
          },
        ),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getActionIcon(
    BuildContext context, {
    required IconData iconData,
    required VoidCallback onPressed,
    Color? iconColor,
  }) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: ColorConstants.white.withOpacity(0.8),
        borderRadius: StyleConstants.radius100,
        boxShadow: StyleConstants.standardShadow,
        border: Border.all(
            color: Theme.of(context).colorScheme.primary, width: 2, strokeAlign: BorderSide.strokeAlignOutside),
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
            size: 16,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
          ),
          splashColor: ColorConstants.blackish.withOpacity(0.4),
        ),
      ),
    );
  }
}
