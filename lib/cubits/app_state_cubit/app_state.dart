import 'dart:ui';

import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/types/playlist.dart';
import 'package:flutter/foundation.dart';

class AppState {
  final RequestErrorObject? error;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Playlist> playlists;
  final String? playlistLoadingName;
  AppState({
    this.error,
    this.primaryColor = ColorConstants.primary,
    this.secondaryColor = ColorConstants.secondary,
    this.playlists = const [],
    this.playlistLoadingName,
  });

  Playlist? getPlaylistByName(String name) {
    return playlists.where((element) => element.name == name).firstOrNull;
  }

  AppState copyWith({
    ValueGetter<RequestErrorObject?>? error,
    Color? primaryColor,
    Color? secondaryColor,
    List<Playlist>? playlists,
    ValueGetter<String?>? playlistLoadingName,
  }) {
    return AppState(
      error: error != null ? error() : this.error,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      playlists: playlists ?? this.playlists,
      playlistLoadingName: playlistLoadingName != null ? playlistLoadingName() : this.playlistLoadingName,
    );
  }
}

class RequestErrorObject {
  String? message;
  String urlAndMethod;
  Object? params;
  Object? response;
  dynamic type;
  RequestErrorObject({this.message, required this.urlAndMethod, this.params, this.type, this.response});
}
