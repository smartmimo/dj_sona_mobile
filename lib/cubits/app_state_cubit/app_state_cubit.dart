import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/view/liked_songs_page/liked_songs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppState());

  void handleNetworkError(DioException error) {
    emit(state.copyWith(
      error: () => RequestErrorObject(
        message: error.message,
        urlAndMethod: "[${error.requestOptions.method.toUpperCase()}] ${error.requestOptions.uri}",
        params: error.requestOptions.data,
        response: error.response?.data,
        type: error.type,
      ),
    ));
  }

  void reset() {
    emit(state.copyWith(error: () => null));
  }

  void updateColors({required Color primary, required Color secondary}) {
    emit(state.copyWith(primaryColor: primary, secondaryColor: secondary));
  }

  void toggleSongLike(SongItem item) {
    if (!isSongLiked(item)) {
      LocalStorageManager.addToLiked(item);
      emit(state.copyWith(
        likedSongs: List<SongItem>.from([item, ...state.likedSongs]),
      ));
    } else {
      LocalStorageManager.removeFromLiked(item);
      emit(state.copyWith(
        likedSongs: List<SongItem>.from(state.likedSongs)..removeWhere((song) => song.id == item.id),
      ));
    }
  }

  void updateLikedSongs() async {
    emit(state.copyWith(
      likedSongs: List<SongItem>.from(await LocalStorageManager.listLiked()),
    ));
  }

  List<SongItem> getLikedSongs() {
    return state.likedSongs;
  }

  bool isSongLiked(SongItem item) {
    final SongItem? likedSong = state.likedSongs.where((song) => song.id == item.id).firstOrNull;
    return likedSong != null;
  }

  bool isSongIdLiked(String songId) {
    final SongItem? likedSong = state.likedSongs.where((song) => song.id == songId).firstOrNull;
    return likedSong != null;
  }

  startLikedSongs({int? startAt}) async {
    final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();

    emit(state.copyWith(isLikedSongsLoading: true));
    await audioService.playPlaylist(
      items: state.likedSongs,
      playlistName: LikedSongsPage.likedSongsPlaylistName,
      startAt: startAt,
    );
    emit(state.copyWith(isLikedSongsLoading: false));
  }
}
