import 'package:djsona_mobile/types/song_item.dart';
import 'package:flutter/foundation.dart';

class MusicSearchState {
  MusicSearchState({
    this.isLoading = false,
    this.songList = const [],
    this.songLoadingId,
    this.isClearHistoryShown = false,
    this.searchString = "",
  });

  final bool isLoading;
  final List<SongItem> songList;
  final String? songLoadingId;
  final bool isClearHistoryShown;
  final String searchString;

  MusicSearchState copyWith({
    bool? isLoading,
    List<SongItem>? songList,
    ValueGetter<String?>? songLoadingId,
    bool? isClearHistoryShown,
    String? searchString,
  }) {
    return MusicSearchState(
      isLoading: isLoading ?? this.isLoading,
      songList: songList ?? this.songList,
      songLoadingId: songLoadingId != null ? songLoadingId() : this.songLoadingId,
      isClearHistoryShown: isClearHistoryShown ?? this.isClearHistoryShown,
      searchString: searchString ?? this.searchString,
    );
  }
}
