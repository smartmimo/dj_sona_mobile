import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/services/downloader_api_provider.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/download_state.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:flutter/material.dart' hide SearchBar;

class DownloadIndicator extends StatefulWidget {
  DownloadIndicator({
    super.key,
    required this.playlist,
    required this.size,
  });

  final Playlist playlist;
  final double size;

  final DownloaderApiProvider downloaderApiProvider = serviceLocator.get<DownloaderApiProvider>();

  @override
  State<DownloadIndicator> createState() => _DownloadIndicatorState();
}

class _DownloadIndicatorState extends State<DownloadIndicator> {
  late DownloadState _downloadState;

  @override
  void initState() {
    _downloadState = DownloadState.idle;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: StyleConstants.radius100,
        border: Border.all(
          color: ColorConstants.white,
          width: 2,
        ),
      ),
      width: widget.size / 1.3,
      height: widget.size / 1.3,
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.hardEdge,
        child: IconButton(
          icon: Icon(
            IconConstants.download,
            size: widget.size / 2.08,
            color: ColorConstants.white,
          ),
          onPressed: _onButtonPressed,
          padding: EdgeInsets.zero,
          splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
          splashRadius: widget.size / 2,
        ),
      ),
    );
  }

  void _onButtonPressed() {
    if (_downloadState == DownloadState.idle) {
      // widget.downloaderApiProvider.downloadPlaylist(
      //   playlist: widget.playlist,
      //   onCurrentProgress: (count, total) => print("$count / $total"),
      //   onTotalProgress: (count, total) => print("$count / $total"),
      // );
    }
  }
}
