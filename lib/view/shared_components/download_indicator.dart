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
    required this.leadingSize,
  });

  final Playlist playlist;
  final double leadingSize;

  final DownloaderApiProvider downloaderApiProvider = serviceLocator.get<DownloaderApiProvider>();

  @override
  State<DownloadIndicator> createState() => _DownloadIndicatorState();
}

class _DownloadIndicatorState extends State<DownloadIndicator> {
  late DownloadState _downloadState;
  late double _progress;

  @override
  void initState() {
    _downloadState = DownloadState.idle;
    _progress = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
        borderRadius: StyleConstants.radius100,
        border: Border.all(
          color: Colors.transparent,
          width: 2,
        ),
      ),
      width: widget.leadingSize / 1.3,
      height: widget.leadingSize / 1.3,
      child: Stack(
        children: [
          CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.white,
            value: _progress,
            strokeAlign: 1,
          ),
          Material(
            type: MaterialType.transparency,
            shape: const CircleBorder(),
            clipBehavior: Clip.hardEdge,
            child: IconButton(
              icon: Icon(
                _getIconByState(),
                size: widget.leadingSize / 2.08,
                color: ColorConstants.white,
              ),
              onPressed: _onButtonPressed,
              padding: EdgeInsets.zero,
              splashColor: Theme.of(context).colorScheme.secondary.withOpacity(1),
              splashRadius: widget.leadingSize / 2,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconByState() {
    if (_downloadState == DownloadState.idle) {
      return IconConstants.download;
    } else if (_downloadState == DownloadState.inProgress) {
      return IconConstants.loading;
    } else {
      return IconConstants.check;
    }
  }

  void _onButtonPressed() {
    if (_downloadState == DownloadState.idle) {
      setState(() {
        _downloadState = DownloadState.inProgress;
      });
      widget.downloaderApiProvider.downloadPlaylist(
        playlist: widget.playlist,
        onCurrentProgress: (count, total) {},
        onTotalProgress: (count, total) => setState(() {
          _progress = count / total;
        }),
        onCurrentDownloadChanged: (p0) {},
      );
    }
  }
}
