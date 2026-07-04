import 'dart:async';

import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:djsona_mobile/cubits/music_search_cubit/music_search_state.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/search_api_provider.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/debounce.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MusicSearchCubit extends Cubit<MusicSearchState> with BlocPresentationMixin<MusicSearchState, MusicSearchEvent> {
  MusicSearchCubit(
    this._searchApiProvider,
    this._audioService,
    this._localStorageManager,
  ) : super(MusicSearchState());

  final SearchApiProvider _searchApiProvider;
  final AudioPlayerService _audioService;
  final LocalStorageManager _localStorageManager;

  StreamSubscription<List<SongItem>>? searchStream;
  final Debounce _debounce = Debounce();

  void init() {
    emit(
      state.copyWith(
        songList: _localStorageManager.listHistory(),
        isLoading: false,
        isClearHistoryShown: true,
        searchString: "",
      ),
    );
  }

  void onSongPressed(SongItem songItem) async {
    emit(state.copyWith(
      songLoadingId: () => songItem.id,
    ));
    try {
      await _audioService.playSong(songItem);
      _localStorageManager.addToHistory(songItem);
    } catch (e) {
      emitPresentation(SongPlaybackErrorEvent(songItem, e.toString()));
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
        emit(state.copyWith(
          songList: songList,
          isLoading: false,
          searchString: text,
        ));
      }),
    );
  }

  void clearHistory() {
    _localStorageManager.clearHistory();
    init();
  }
}

class SongPlaybackErrorEvent extends MusicSearchEvent {
  final SongItem songItem;
  final String errorMessage;

  SongPlaybackErrorEvent(this.songItem, this.errorMessage);
}

class MusicSearchEvent {}
