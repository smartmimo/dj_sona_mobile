import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:just_audio/just_audio.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class AudioPlayerService extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayer();
  final SearchApiProvider _searchApiProvider = serviceLocator.get<SearchApiProvider>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  AudioPlayerService() {
    audioPlayer.playbackEventStream.map(_transformEvent).pipe(playbackState);
    mediaItem.listen((value) {
      if (value == null) return;

      if (queue.value.isEmpty || queue.value.indexOf(value) == queue.value.length - 1) {
        autoPlayFromCurrentItem(value);
      }
    });
  }

  Future<AudioOnlyStreamInfo> _getAudioStreamFromId(String videoId) async {
    final YoutubeExplode yt = YoutubeExplode();
    final StreamManifest manifest = await yt.videos.streamsClient.getManifest(videoId);
    final AudioOnlyStreamInfo audioStreamInfo = manifest.audioOnly.withHighestBitrate();
    yt.close();
    return audioStreamInfo;
  }

  Future<Video> _getVideoDatafromId(String videoId) async {
    final YoutubeExplode yt = YoutubeExplode();
    final Video manifest = await yt.videos.get(videoId);
    yt.close();
    return manifest;
  }

  Future<void> playSong(SongItem songItem) async {
    final AudioOnlyStreamInfo audioStreamInfo = await _getAudioStreamFromId(songItem.id);
    final MediaItem item = MediaItem(
      id: songItem.id,
      title: songItem.title,
      duration: songItem.duration,
      artUri: songItem.thumbnailUrl != null ? Uri.parse(songItem.thumbnailUrl!) : null,
      extras: {
        "streamUrl": audioStreamInfo.url.toString(),
      },
    );

    audioPlayer.setUrl(audioStreamInfo.url.toString());
    clearQueue();
    broadcastMediaItem(item);
    if (!audioPlayer.playing) audioPlayer.play();
    return;
  }

  @override
  Future<void> play() => audioPlayer.play();

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
    audioPlayer.setUrl(nextItem.extras!["streamUrl"]);
    broadcastMediaItem(nextItem);
    if (!audioPlayer.playing) audioPlayer.play();
  }

  @override
  Future<void> skipToPrevious() async {
    final int currentIndex = queue.value.indexOf(mediaItem.value!);
    if (currentIndex - 1 < 0) return;

    final MediaItem previousItem = queue.value[currentIndex - 1];
    audioPlayer.setUrl(previousItem.id);
    broadcastMediaItem(previousItem);
    if (!audioPlayer.playing) audioPlayer.play();
  }

  @override
  Future<void> setShuffleMode(AudioServiceShuffleMode shuffleMode) {
    return audioPlayer.setShuffleModeEnabled(shuffleMode != AudioServiceShuffleMode.none);
  }

  @override
  Future<void> setRepeatMode(AudioServiceRepeatMode repeatMode) {
    return audioPlayer.setLoopMode(repeatMode == AudioServiceRepeatMode.none ? LoopMode.off : LoopMode.all);
  }

  void broadcastMediaItem(MediaItem item) {
    if (StringUtils.isNotEmpty(item.artUri?.toString())) {
      ImageUtils.getDominantColorsFromImageUrl(item.artUri!.toString()).then((value) {
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

      mediaItem.add(item);
    }
  }

  PlaybackState _transformEvent(PlaybackEvent event) {
    if (event.processingState == ProcessingState.completed) skipToNext();

    return PlaybackState(
      controls: [
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.stop,
        MediaControl.skipToNext,
      ],
      systemActions: const {
        MediaAction.seek,
        MediaAction.skipToNext,
        MediaAction.skipToPrevious,
      },
      androidCompactActionIndices: const [0, 1, 3],
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
      final AudioOnlyStreamInfo audioStreamInfo = await _getAudioStreamFromId(videoId);
      final Video videoDetails = await _getVideoDatafromId(videoId);
      final MediaItem item = MediaItem(
        id: videoId,
        title: videoDetails.title,
        duration: videoDetails.duration,
        artUri: Uri.parse(videoDetails.thumbnails.highResUrl),
        extras: {
          "streamUrl": audioStreamInfo.url.toString(),
        },
      );
      addQueueItem(item);
    }
  }

  void clearQueue() {
    queue.value = [];
  }
}
