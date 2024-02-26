import 'dart:ui';

import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/types/song_item.dart';
import 'package:flutter/foundation.dart';

class AppState {
  final RequestErrorObject? error;
  final Color primaryColor;
  final Color secondaryColor;
  final List<SongItem> likedSongs;
  final bool isLikedSongsLoading;
  AppState({
    this.error,
    this.primaryColor = ColorConstants.primary,
    this.secondaryColor = ColorConstants.secondary,
    this.likedSongs = const [],
    this.isLikedSongsLoading = false,
  });

  AppState copyWith({
    ValueGetter<RequestErrorObject?>? error,
    Color? primaryColor,
    Color? secondaryColor,
    List<SongItem>? likedSongs,
    bool? isLikedSongsLoading,
  }) {
    return AppState(
      error: error != null ? error() : this.error,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      likedSongs: likedSongs ?? this.likedSongs,
      isLikedSongsLoading: isLikedSongsLoading ?? this.isLikedSongsLoading,
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
