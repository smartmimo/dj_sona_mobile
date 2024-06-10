import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:djsona_mobile/services/api/api_service.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/youtube_utils.dart';

class DownloaderApiProvider {
  final ApiService _apiService;
  final LocalStorageManager _localStorageManager;
  const DownloaderApiProvider(this._apiService, this._localStorageManager);

  Future<Response<Uint8List>> _downloadSong({
    required MediaItemWrapper mediaItem,
    required Function(int, int) onProgress,
  }) async {
    return _apiService.dio.getUri<Uint8List>(
      Uri.parse(mediaItem.extras.streamUrl),
      options: Options(
        receiveTimeout: null,
        headers: {
          'Range': 'bytes=0-',
        },
        responseType: ResponseType.bytes,
      ),
      onReceiveProgress: onProgress, //inBytes
    );
  }

  void downloadPlaylist({
    required Playlist playlist,
    required Function(int, int) onCurrentProgress,
    required Function(int, int) onTotalProgress,
    required Function(MediaItemWrapper) onCurrentDownloadChanged,
    required void Function() onDone,
  }) async {
    final List<MediaItemWrapper> mediaItems = await Future.wait(
      playlist.songList.map(YoutubeUtils.getMediaItemFromSongItem),
    );

    final List<MediaItemWrapper> alreadyDownloadedItems = mediaItems
        .where(
          (song) => _localStorageManager.isSongDownloaded(song.id),
        )
        .toList();

    final int totalSizeInBytes = mediaItems.map((e) => e.extras.fileSize).reduce((a, b) => a + b);
    final int alreadyDownloadItemsSizeInBytes = alreadyDownloadedItems.isNotEmpty
        ? alreadyDownloadedItems
            .map(
              (e) => e.extras.fileSize,
            )
            .reduce((a, b) => a + b)
        : 0;

    int totalCount = alreadyDownloadItemsSizeInBytes;
    int offset = 0;

    onTotalProgress(totalCount, totalSizeInBytes);

    for (final MediaItemWrapper mediaItem in mediaItems) {
      onCurrentDownloadChanged(mediaItem);
      offset = totalCount;

      if (_localStorageManager.isSongDownloaded(mediaItem.id)) {
        continue;
      }

      final Response<Uint8List> response = await _downloadSong(
        mediaItem: mediaItem,
        onProgress: (currentCount, currentTotal) {
          totalCount = offset + currentCount;
          onCurrentProgress(currentCount, currentTotal);
          onTotalProgress(totalCount, totalSizeInBytes);
        },
      );

      _localStorageManager.saveSongToDownloads(mediaItem.id, response.data!);
    }

    onDone();
  }
}
