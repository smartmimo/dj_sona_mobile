import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/media_item_extras.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/youtube_utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioPlayerService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayer();
  final SearchApiProvider _searchApiProvider = serviceLocator.get<SearchApiProvider>();
  final LocalStorageManager _localStorageManager = serviceLocator.get<LocalStorageManager>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  AudioPlayerService() {
    audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.listen((value) {
      if (value == null) return;

      final bool mustAutoPlay = queue.value.isEmpty || queue.value.indexOf(value) == queue.value.length - 1;
      final bool canAutoPlay = _appStateCubit.state.connectivityResult != ConnectivityResult.none;

      if (mustAutoPlay && canAutoPlay) {
        autoPlayFromCurrentItem(value);
      }
    });
  }

  Future<MediaItemWrapper> _getMediaItemFromSongItem(
    SongItem songItem, {
    int? originalIndex,
    int? shuffledIndex,
  }) {
    if (_localStorageManager.isSongDownloaded(songItem.id)) {
      return Future.value(songItem.toMediaItemWrapper(
        extras: MediaItemExtras(
          streamUrl: _localStorageManager.getSongDownloadPath(songItem.id),
          originalIndex: originalIndex,
          shuffledIndex: shuffledIndex,
          fileSize: 69, //Not needed for downloaded songs
        ),
      ));
    } else {
      return YoutubeUtils.getMediaItemFromSongItem(songItem);
    }
  }

  AudioSource _getAudioSourceFromUrl(String url) {
    if (url.startsWith("http")) {
      return AudioSource.uri(Uri.parse(url));
    } else {
      return AudioSource.uri(Uri.file(url));
    }
  }

  void _setAudioSource(AudioSource source) {
    audioPlayer.setAudioSource(source).catchError(_appStateCubit.onPlaybackError);
  }

  Future<MediaItemWrapper> playSong(SongItem songItem) async {
    final MediaItemWrapper item = await _getMediaItemFromSongItem(songItem);

    _setAudioSource(_getAudioSourceFromUrl(item.extras.streamUrl));

    clearQueue();
    broadcastMediaItem(item.toMediaItem().copyWith(artist: "Search"));
    if (!audioPlayer.playing) play();
    return item;
  }

  Future<void> playPlaylist({
    required List<SongItem> playlistItems,
    required String playlistName,
    int? startAt,
  }) async {
    final playableItems = List<SongItem>.from(
      playlistItems.where((song) => _appStateCubit.isSongIdPlayable(song.id)),
    );
    if (playableItems.isEmpty) return;

    final List<SongItem> shuffledItems = List<SongItem>.from(playableItems)..shuffle();
    late final List<SongItem> songItems;
    clearQueue();

    if (audioPlayer.shuffleModeEnabled) {
      songItems = shuffledItems;
    } else {
      songItems = List<SongItem>.from(playableItems);
    }

    if (startAt != null) {
      final int startAtFromPlayableItems = playableItems.indexWhere((song) => song.id == playlistItems[startAt].id);
      if (startAtFromPlayableItems != -1) {
        var tmp = songItems[0];
        songItems[0] = songItems[startAtFromPlayableItems];
        songItems[startAtFromPlayableItems] = tmp;
      }
    }

    final MediaItemWrapper firstMediaItem = await _getMediaItemFromSongItem(
      songItems[0],
      originalIndex: playableItems.indexWhere((e) => e.id == songItems[0].id),
      shuffledIndex: shuffledItems.indexWhere((e) => e.id == songItems[0].id),
    );
    queueTitle.value = playlistName;
    addQueueItem(firstMediaItem.toMediaItem().copyWith(artist: playlistName));

    if (songItems.length <= 1) {
      _setAudioSource(_getAudioSourceFromUrl(firstMediaItem.extras.streamUrl));
      broadcastMediaItem(firstMediaItem.toMediaItem().copyWith(artist: playlistName));
      if (!audioPlayer.playing) audioPlayer.play();
      return;
    }

    final MediaItemWrapper secondMediaItem = await _getMediaItemFromSongItem(
      songItems[1],
      originalIndex: playableItems.indexWhere((e) => e.id == songItems[1].id),
      shuffledIndex: shuffledItems.indexWhere((e) => e.id == songItems[1].id),
    );
    addQueueItem(secondMediaItem.toMediaItem().copyWith(artist: playlistName));

    _setAudioSource(_getAudioSourceFromUrl(firstMediaItem.extras.streamUrl));
    broadcastMediaItem(firstMediaItem.toMediaItem().copyWith(artist: playlistName));
    if (!audioPlayer.playing) audioPlayer.play();

    List<MediaItemWrapper> mediaItemList = await Future.wait<MediaItemWrapper>(
      songItems.getRange(2, songItems.length).map(
            (songItem) => _getMediaItemFromSongItem(
              songItem,
              originalIndex: playableItems.indexWhere((e) => songItem.id == e.id),
              shuffledIndex: shuffledItems.indexWhere((e) => songItem.id == e.id),
            ),
          ),
    );

    addQueueItems(mediaItemList.map((item) => item.toMediaItem().copyWith(artist: playlistName)).toList());
    return;
  }

  @override
  Future<void> play() {
    try {
      return audioPlayer.play();
    } catch (e) {
      return Future.delayed(const Duration(seconds: 1), play);
    }
  }

  Future<void> replay() => audioPlayer.seek(Duration.zero).then((_) => play());

  @override
  Future<void> pause() => audioPlayer.pause();

  @override
  Future<void> seek(Duration position) => audioPlayer.seek(position);

  @override
  Future<void> stop() => audioPlayer.stop();

  @override
  Future<void> skipToNext() async {
    if (audioPlayer.loopMode == LoopMode.all) return replay();
    final int currentIndex = queue.value.indexOf(mediaItem.value!);
    if (currentIndex + 1 > queue.value.length - 1) return;

    final MediaItem nextItem = queue.value[currentIndex + 1];
    _setAudioSource(
      _getAudioSourceFromUrl(
        MediaItemWrapper.fromMediaItem(nextItem).extras.streamUrl,
      ),
    );
    broadcastMediaItem(nextItem);
    if (!audioPlayer.playing) play();
  }

  @override
  Future<void> skipToPrevious() async {
    final int currentIndex = queue.value.indexOf(mediaItem.value!);
    if (currentIndex - 1 < 0 || audioPlayer.position > const Duration(seconds: 5)) {
      seek(Duration.zero);
      return;
    }

    final MediaItem previousItem = queue.value[currentIndex - 1];
    _setAudioSource(
      _getAudioSourceFromUrl(
        MediaItemWrapper.fromMediaItem(previousItem).extras.streamUrl,
      ),
    );
    broadcastMediaItem(previousItem);
    if (!audioPlayer.playing) play();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) async {
    final bool isShuffleEnabled = shuffleMode != AudioServiceShuffleMode.none;
    audioPlayer.setShuffleModeEnabled(isShuffleEnabled);

    if (StringUtils.isNotEmpty(queueTitle.value)) {
      final shuffleParameter = isShuffleEnabled ? "shuffledIndex" : "originalIndex";
      queue.value.sort((a, b) => a.extras![shuffleParameter] - b.extras![shuffleParameter]);
    }
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
    return audioPlayer.setLoopMode(repeatMode == AudioServiceRepeatMode.none ? LoopMode.off : LoopMode.all);
  }

  void broadcastMediaItem(MediaItem item) async {
    final String? cachedThumbnail = await _localStorageManager.getCachedImagePath(item.artUri.toString());
    late final Uri? thumbToProcess;

    if (cachedThumbnail != null) {
      item = item.copyWith(artUri: Uri.file(cachedThumbnail));
      thumbToProcess = Uri.file(cachedThumbnail);
    } else if (_appStateCubit.state.connectivityResult != ConnectivityResult.none) {
      thumbToProcess = item.artUri;
    } else {
      thumbToProcess = null;
    }

    if (thumbToProcess != null) {
      ImageUtils.getDominantColorsFromImageUrl(thumbToProcess.toString()).then((value) {
        _appStateCubit.updateColors(
          primary: value.darkVibrantColor?.color ??
              ImageUtils.darkenColor(
                ImageUtils.getAverageColorFromList(value.colors.toList()),
              ),
          secondary: value.lightMutedColor?.color ??
              ImageUtils.lightenColor(
                ImageUtils.getAverageColorFromList(value.colors.toList()),
              ),
        );
      });
    }

    mediaItem.add(item);
  }

  @override
  Future<dynamic> customAction(String name, [Map<String, dynamic>? extras]) async {
    if (name == 'toggleLikeToCurrentItem') {
      if (mediaItem.value == null) return;
      _appStateCubit.toggleSongLike(
        SongItem.fromMediaItem(
          MediaItemWrapper.fromMediaItem(mediaItem.value!),
        ),
      );
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (event.processingState == ProcessingState.completed) Future.delayed(const Duration(seconds: 1), skipToNext);
    return PlaybackState(
      controls: [
        if (mediaItem.value != null) ...{
          MediaControl(
            androidIcon: _appStateCubit.isSongIdLiked(
              mediaItem.value!.id,
            )
                ? 'drawable/heart_filled'
                : 'drawable/heart',
            label: 'Previous',
            action: MediaAction.custom,
            customAction: const CustomMediaAction(name: "toggleLikeToCurrentItem"),
          ),
        },
        MediaControl.skipToPrevious.copyWith(androidIcon: "drawable/previous"),
        if (audioPlayer.playing)
          MediaControl.pause.copyWith(androidIcon: "drawable/pause")
        else
          MediaControl.play.copyWith(androidIcon: "drawable/play"),
        MediaControl.skipToNext.copyWith(androidIcon: "drawable/next"),
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: mediaItem.value != null ? const [1, 2, 3] : const [0, 1, 2],
      processingState: const {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: event.currentIndex,
      shuffleMode: audioPlayer.shuffleModeEnabled ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
      repeatMode: audioPlayer.loopMode == LoopMode.all ? AudioServiceRepeatMode.all : AudioServiceRepeatMode.none,
    );
  }

  void autoPlayFromCurrentItem(MediaItem currentItem) async {
    final List<String> relatedVideoIds = await _searchApiProvider.getRelatedVideosFromId(currentItem.id);
    if (relatedVideoIds.isEmpty) return;

    clearQueue();
    addQueueItem(currentItem);
    for (final String videoId in relatedVideoIds) {
      final AudioOnlyStreamInfo audioStreamInfo = await YoutubeUtils.getAudioStreamFromVideoId(videoId);
      final Video videoDetails = await YoutubeUtils.getVideoDatafromId(videoId);

      final MediaItemWrapper item = MediaItemWrapper(
        id: videoId,
        title: videoDetails.title,
        duration: videoDetails.duration,
        artUri: Uri.parse(videoDetails.thumbnails.highResUrl),
        extras: MediaItemExtras(
          streamUrl: audioStreamInfo.url.toString(),
          publishedTimeString: StringUtils.timeAgo(videoDetails.publishDate),
          viewsString: StringUtils.viewsToKMBFormat(videoDetails.engagement.viewCount),
          fileSize: audioStreamInfo.size.totalBytes,
        ),
      );
      addQueueItem(item.toMediaItem().copyWith(artist: "Autoplay"));
    }
  }

  void clearQueue() {
    queueTitle.value = "";
    queue.value = [];
  }
}
