import 'package:djsona_mobile/types/song_item.dart';
import 'package:flutter/foundation.dart';

class MusicSearchState {
  MusicSearchState({
    this.isLoading = false,
    this.songList = const [],
    this.songLoadingId,
  });

  final bool isLoading;
  final List<SongItem> songList;
  final String? songLoadingId;

  MusicSearchState copyWith({
    bool? isLoading,
    List<SongItem>? songList,
    ValueGetter<String?>? songLoadingId,
  }) {
    return MusicSearchState(
      isLoading: isLoading ?? this.isLoading,
      songList: songList ?? this.songList,
      songLoadingId: songLoadingId != null ? songLoadingId() : this.songLoadingId,
    );
  }
}
