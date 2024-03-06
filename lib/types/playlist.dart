import 'package:djsona_mobile/types/song_item.dart';

class Playlist {
  final String name;
  final List<SongItem> songList;

  Playlist({
    required this.name,
    required this.songList,
  });

  Playlist copyWith({
    String? name,
    List<SongItem>? songList,
  }) {
    return Playlist(
      name: name ?? this.name,
      songList: songList ?? this.songList,
    );
  }
}
