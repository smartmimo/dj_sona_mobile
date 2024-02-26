import 'dart:math';

class SongItem {
  final String id;
  final String youtubeUrl;
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

  SongItem({
    required this.id,
    required this.youtubeUrl,
    required this.title,
    required this.durationString,
    required this.publishedTimeString,
    required this.viewsString,
    required this.thumbnailUrl,
  });

  SongItem copyWith({
    String? id,
    String? youtubeUrl,
    String? title,
    String? durationString,
    String? publishedTimeString,
    String? viewsString,
    String? thumbnailUrl,
  }) {
    return SongItem(
      id: id ?? this.id,
      youtubeUrl: youtubeUrl ?? this.youtubeUrl,
      title: title ?? this.title,
      durationString: durationString ?? this.durationString,
      publishedTimeString: publishedTimeString ?? this.publishedTimeString,
      viewsString: viewsString ?? this.viewsString,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
    );
  }
}
