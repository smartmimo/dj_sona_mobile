import 'dart:async';

import 'package:djsona_mobile/cubits/music_search_cubit/music_search_state.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/debounce.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicSearchCubit extends Cubit<MusicSearchState> {
  MusicSearchCubit(
    this._searchApiProvider,
    this._audioService,
  ) : super(MusicSearchState());

  final SearchApiProvider _searchApiProvider;
  final AudioPlayerService _audioService;

  StreamSubscription<List<SongItem>>? searchStream;
  final Debounce _debounce = Debounce();

  void init() {
    LocalStorageManager.listHistory().then(
      (value) => emit(
        state.copyWith(
          songList: value,
          isLoading: false,
          isClearHistoryShown: true,
        ),
      ),
    );
  }

  void onSongPressed(SongItem songItem) async {
    emit(state.copyWith(
      songLoadingId: () => songItem.id,
    ));
    try {
      await _audioService.playSong(songItem);
      LocalStorageManager.addToHistory(songItem);
    } finally {
      emit(state.copyWith(
        songLoadingId: () => null,
      ));
    }
  }

  void onSearchChanged(String? text) {
    searchStream?.cancel();

    if (StringUtils.isEmpty(text)) return init();

    emit(state.copyWith(isLoading: true, isClearHistoryShown: false));
    searchStream = _debounce(
      () => _searchApiProvider.searchByText(text!).asStream().listen((songList) {
        emit(state.copyWith(songList: songList, isLoading: false));
      }),
    );
  }

  void clearHistory() {
    LocalStorageManager.clearHistory().then((_) => init());
  }
}
