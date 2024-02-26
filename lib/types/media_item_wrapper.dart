import 'package:audio_service/audio_service.dart';
import 'package:djsona_mobile/types/media_item_extras.dart';

class MediaItemWrapper {
  final String id;
  final String title;
  final String? album;
  final String? artist;
  final String? genre;
  final Duration? duration;
  final Uri? artUri;
  final Map<String, String>? artHeaders;
  final bool? playable;
  final String? displayTitle;
  final String? displaySubtitle;
  final String? displayDescription;
  final Rating? rating;
  final MediaItemExtras extras;

  const MediaItemWrapper({
    required this.id,
    required this.title,
    this.album,
    this.artist,
    this.genre,
    this.duration,
    this.artUri,
    this.artHeaders,
    this.playable = true,
    this.displayTitle,
    this.displaySubtitle,
    this.displayDescription,
    this.rating,
    required this.extras,
  });

  factory MediaItemWrapper.fromMediaItem(MediaItem mediaItem) {
    return MediaItemWrapper(
      id: mediaItem.id,
      title: mediaItem.title,
      album: mediaItem.album,
      artist: mediaItem.artist,
      genre: mediaItem.genre,
      duration: mediaItem.duration,
      artUri: mediaItem.artUri,
      artHeaders: mediaItem.artHeaders,
      playable: mediaItem.playable,
      displayTitle: mediaItem.displayTitle,
      displaySubtitle: mediaItem.displaySubtitle,
      displayDescription: mediaItem.displayDescription,
      rating: mediaItem.rating,
      extras: MediaItemExtras.fromJson(mediaItem.extras!),
    );
  }

  MediaItem toMediaItem() {
    return MediaItem(
      id: id,
      title: title,
      album: album,
      artist: artist,
      genre: genre,
      duration: duration,
      artUri: artUri,
      artHeaders: artHeaders,
      playable: playable,
      displayTitle: displayTitle,
      displaySubtitle: displaySubtitle,
      displayDescription: displayDescription,
      rating: rating,
      extras: extras.toJson(),
    );
  }
}
