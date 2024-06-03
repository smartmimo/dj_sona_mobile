import 'dart:math';

import 'package:djsona_mobile/types/media_item_extras.dart';
import 'package:djsona_mobile/types/media_item_wrapper.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/string_utils.dart';

class SongItem {
  final String id;
  final String title;
  final String? durationString;
  final String? publishedTimeString;
  final String? viewsString;
  final String? thumbnailUrl;

  Duration get duration {
    final List<int> durationFragments = durationString!
        .split(":")
        .map(
          (fragment) => int.parse(fragment),
        )
        .toList()
        .reversed
        .toList();
    return Duration(seconds: durationFragments.reduce((a, b) {
      final num firstElementInSeconds = a * pow(60, durationFragments.indexOf(a));
      final num secondElementInSeconds = b * pow(60, durationFragments.indexOf(b));
      return (firstElementInSeconds + secondElementInSeconds).toInt();
    }));
  }

  const SongItem({
    required this.id,
    required this.title,
    required this.durationString,
    required this.publishedTimeString,
    required this.viewsString,
    required this.thumbnailUrl,
  });

  factory SongItem.fromJson(Map<String, dynamic> json) {
    return SongItem(
      id: json['id'],
      title: json['title'],
      durationString: json['durationString'],
      publishedTimeString: json['publishedTimeString'],
      viewsString: json['viewsString'],
      thumbnailUrl: json['thumbnailUrl'],
    );
  }

  factory SongItem.fromMediaItem(MediaItemWrapper mediaItem) {
    return SongItem(
      id: mediaItem.id,
      title: mediaItem.title,
      durationString: StringUtils.prettyDuration(mediaItem.duration),
      publishedTimeString: mediaItem.extras.publishedTimeString,
      viewsString: mediaItem.extras.viewsString,
      thumbnailUrl: mediaItem.artUri?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'durationString': durationString,
      'publishedTimeString': publishedTimeString,
      'viewsString': viewsString,
      'thumbnailUrl': thumbnailUrl,
    };
  }

  MediaItemWrapper toMediaItemWrapper({
    required MediaItemExtras extras,
  }) {
    return MediaItemWrapper(
      id: id,
      title: title,
      duration: duration,
      artUri: thumbnailUrl != null ? Uri.parse(thumbnailUrl!) : null,
      extras: extras.copyWith(publishedTimeString: publishedTimeString, viewsString: viewsString),
    );
  }

  bool isDownloaded(LocalStorageManager localStorageManager) {
    return localStorageManager.isSongDownloaded(id);
  }
}
