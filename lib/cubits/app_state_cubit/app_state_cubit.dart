import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/error_types/playlist_exists_error.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/error_types/request_error_object.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

class AppStateCubit extends Cubit<AppState> {
  final LocalStorageManager _localStorageManager;
  AppStateCubit(
    this._localStorageManager,
    ConnectivityResult connectivity,
  ) : super(AppState(connectivityResult: connectivity)) {
    Connectivity().onConnectivityChanged.listen((event) {
      updateConnectivityResult(event);
    });
  }

  void init() async {
    final List<Playlist> playlistsAndLikedSongs = _localStorageManager.listPlaylists();
    emit(state.copyWith(playlistsAndLikedSongs: playlistsAndLikedSongs, playlistLoadingName: () => null));
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
    try {
      await audioService.playPlaylist(
        playlistItems: playlist.songList,
        playlistName: playlistName,
        startAt: startAt,
      );
    } finally {
      emit(state.copyWith(playlistLoadingName: () => null));
    }
  }

  addItemToPlaylist({required String playlistName, required SongItem item}) {
    _localStorageManager.addToPlaylist(playlistName: playlistName, item: item);
    emit(state.copyWith(
      playlistsAndLikedSongs: List<Playlist>.from(
        state.playlistsAndLikedSongs.map((playlist) {
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
    _localStorageManager.removeFromPlaylist(playlistName: playlistName, item: item);
    emit(state.copyWith(
      playlistsAndLikedSongs: List<Playlist>.from(
        state.playlistsAndLikedSongs.map((playlist) {
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
    return isSongInPlaylist(playlistName: AppConstants.likedSongsPlaylistName, item: item);
  }

  bool isSongIdLiked(String songId) {
    final SongItem? likedSong = state
        .getPlaylistByName(AppConstants.likedSongsPlaylistName)
        ?.songList
        .where((song) => song.id == songId)
        .firstOrNull;
    return likedSong != null;
  }

  Playlist newPlaylist(String playlistName) {
    if (state.getPlaylistByName(playlistName) != null) throw PlaylistExistsError();

    _localStorageManager.newPlaylist(playlistName);

    final Playlist addedPlaylist = Playlist(
      name: playlistName,
      creationDate: DateTime.now(),
      songList: [],
    );

    emit(
      state.copyWith(
        playlistsAndLikedSongs: List<Playlist>.from(
          [
            addedPlaylist,
            ...state.playlistsAndLikedSongs,
          ],
        ),
      ),
    );
    return addedPlaylist;
  }

  deletePlaylist(String playlistName) {
    _localStorageManager.deletePlaylist(playlistName);
    emit(state.copyWith(
      playlistsAndLikedSongs: List<Playlist>.from(
        state.playlistsAndLikedSongs..removeWhere((playlist) => playlist.name == playlistName),
      ),
    ));
  }

  bool isSongInPlaylist({required String playlistName, required SongItem item}) {
    final SongItem? likedSong = state
        .getPlaylistByName(
          playlistName,
        )
        ?.songList
        .where((song) => song.id == item.id)
        .firstOrNull;
    return likedSong != null;
  }

  bool isSongIdPlayable(String songId) {
    return state.connectivityResult != ConnectivityResult.none || _localStorageManager.isSongDownloaded(songId);
  }

  bool isSongIdDownloaded(String songId) {
    return _localStorageManager.isSongDownloaded(songId);
  }

  void updateConnectivityResult(ConnectivityResult value) {
    emit(state.copyWith(connectivityResult: value));
  }
}
