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
  final List<Playlist> playlistsWithLikedSongs;
  final String? playlistLoadingName;
  AppState({
    this.error,
    this.primaryColor = ColorConstants.primary,
    this.secondaryColor = ColorConstants.secondary,
    this.playlistsWithLikedSongs = const [],
    this.playlistLoadingName,
  });

  List<Playlist> get playlists => List<Playlist>.from(
        playlistsWithLikedSongs.where((playlist) => playlist.name != AppConstants.likedSongsPlaylistName),
      );

  Playlist? getPlaylistByName(String name) {
    return playlistsWithLikedSongs.where((element) => element.name == name).firstOrNull;
  }

  AppState copyWith({
    ValueGetter<RequestErrorObject?>? error,
    Color? primaryColor,
    Color? secondaryColor,
    List<Playlist>? playlistsWithLikedSongs,
    ValueGetter<String?>? playlistLoadingName,
  }) {
    return AppState(
      error: error != null ? error() : this.error,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      playlistsWithLikedSongs: playlistsWithLikedSongs ?? this.playlistsWithLikedSongs,
      playlistLoadingName: playlistLoadingName != null ? playlistLoadingName() : this.playlistLoadingName,
    );
  }
}
