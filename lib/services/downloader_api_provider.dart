import 'package:dio/dio.dart';
import 'package:djsona_mobile/services/api/api_service.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/utils/youtube_utils.dart';

class DownloaderApiProvider {
  final ApiService _apiService;
  const DownloaderApiProvider(this._apiService);

  Future<Response> _downloadSong({
    required MediaItemWrapper mediaItem,
    required Function(int, int) onProgress,
  }) async {
    return _apiService.dio.getUri(
      Uri.parse(mediaItem.extras.streamUrl),
      options: Options(
        receiveTimeout: null,
        headers: {
          'Range': 'bytes=0-',
        },
      ),
      onReceiveProgress: onProgress, //inBytes
    );
  }

  void downloadPlaylist({
    required Playlist playlist,
    required Function(int, int) onCurrentProgress,
    required Function(int, int) onTotalProgress,
    required Function(MediaItemWrapper) onCurrentDownloadChanged,
  }) async {
    final List<MediaItemWrapper> mediaItems = await Future.wait(
      playlist.songList.map(YoutubeUtils.getMediaItemFromSongItem),
    );

    // final String generalPath = (await getExternalStorageDirectory())!.path;

    final int totalSizeInBytes = mediaItems.map((e) => e.extras.fileSize).reduce((a, b) => a + b);

    int totalCount = 0;
    int offset = 0;

    for (final MediaItemWrapper mediaItem in mediaItems) {
      onCurrentDownloadChanged(mediaItem);
      offset = totalCount;
      await _downloadSong(
        mediaItem: mediaItem,
        onProgress: (currentCount, currentTotal) {
          totalCount = offset + currentCount;
          onCurrentProgress(currentCount, currentTotal);
          onTotalProgress(totalCount, totalSizeInBytes);
        },
      );
    }
  }
}
