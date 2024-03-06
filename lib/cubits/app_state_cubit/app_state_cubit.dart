import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class AppStateCubit extends Cubit<AppState> {
  AppStateCubit() : super(AppState());

  void init() async {
    final List<Playlist> playlists = await LocalStorageManager.listPlaylists();
    emit(state.copyWith(playlists: playlists, playlistLoadingName: () => null));
  }

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

  startPlaylist({required String playlistName, int? startAt}) async {
    final AudioPlayerService audioService = serviceLocator.get<AudioPlayerService>();
    final Playlist? playlist = state.getPlaylistByName(playlistName);
    if (playlist == null) return;

    emit(state.copyWith(playlistLoadingName: () => playlistName));
    await audioService.playPlaylist(
      items: playlist.songList,
      playlistName: playlistName,
      startAt: startAt,
    );
    emit(state.copyWith(playlistLoadingName: () => null));
  }

  addItemToPlaylist({required String playlistName, required SongItem item}) {
    LocalStorageManager.addToPlaylist(playlistName: playlistName, item: item);
    emit(state.copyWith(
      playlists: List<Playlist>.from(
        state.playlists.map((playlist) {
          if (playlist.name == playlistName) {
            return playlist.copyWith(songList: List<SongItem>.from([item, ...playlist.songList]));
          } else {
            return playlist;
          }
        }),
      ),
    ));
  }

  removeItemFromPlaylist({required String playlistName, required SongItem item}) {
    LocalStorageManager.removeFromPlaylist(playlistName: playlistName, item: item);
    emit(state.copyWith(
      playlists: List<Playlist>.from(
        state.playlists.map((playlist) {
          if (playlist.name == playlistName) {
            return playlist.copyWith(
              songList: List<SongItem>.from(playlist.songList)..removeWhere((song) => song.id == item.id),
            );
          } else {
            return playlist;
          }
        }),
      ),
    ));
  }

  List<SongItem> getPlaylistSongs({required String playlistName}) {
    return state.getPlaylistByName(playlistName)?.songList ?? [];
  }

  void toggleSongLike(SongItem item) {
    if (isSongLiked(item)) {
      removeItemFromPlaylist(playlistName: AppConstants.likedSongsPlaylistName, item: item);
    } else {
      addItemToPlaylist(playlistName: AppConstants.likedSongsPlaylistName, item: item);
    }
  }

  List<SongItem> getLikedSongs() {
    return getPlaylistSongs(playlistName: AppConstants.likedSongsPlaylistName);
  }

  bool isSongLiked(SongItem item) {
    final SongItem? likedSong = state
        .getPlaylistByName(AppConstants.likedSongsPlaylistName)
        ?.songList
        .where((song) => song.id == item.id)
        .firstOrNull;
    return likedSong != null;
  }

  bool isSongIdLiked(String songId) {
    final SongItem? likedSong = state
        .getPlaylistByName(AppConstants.likedSongsPlaylistName)
        ?.songList
        .where((song) => song.id == songId)
        .firstOrNull;
    return likedSong != null;
  }
}
