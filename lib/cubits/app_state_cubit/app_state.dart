import 'dart:ui';

import 'package:djsona_mobile/constants/app_constants.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/error_types/request_error_object.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:flutter/foundation.dart';

class AppState {
  final RequestErrorObject? error;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Playlist> playlistsAndLikedSongs;
  final String? playlistLoadingName;
  AppState({
    this.error,
    this.primaryColor = ColorConstants.primary,
    this.secondaryColor = ColorConstants.secondary,
    this.playlistsAndLikedSongs = const [],
    this.playlistLoadingName,
  });

  List<Playlist> get playlists => List<Playlist>.from(
        playlistsAndLikedSongs.where((playlist) => playlist.name != AppConstants.likedSongsPlaylistName),
      );

  Playlist? getPlaylistByName(String name) {
    return playlistsAndLikedSongs.where((element) => element.name == name).firstOrNull;
  }

  AppState copyWith({
    ValueGetter<RequestErrorObject?>? error,
    Color? primaryColor,
    Color? secondaryColor,
    List<Playlist>? playlistsAndLikedSongs,
    ValueGetter<String?>? playlistLoadingName,
  }) {
    return AppState(
      error: error != null ? error() : this.error,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      playlistsAndLikedSongs: playlistsAndLikedSongs ?? this.playlistsAndLikedSongs,
      playlistLoadingName: playlistLoadingName != null ? playlistLoadingName() : this.playlistLoadingName,
    );
  }
}
