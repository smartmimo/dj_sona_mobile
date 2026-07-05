import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/router/app_router.dart';

class MenuItem {
  MenuItem(
    this.text,
    this.icon,
    this.activeIcon,
    this.route,
    {this.isVisible = true}
  );

  final String text;
  final IconData icon;
  final IconData activeIcon;
  final PageRouteInfo route;
  final bool isVisible;
}

abstract class MenuItemsManager {
  static final _homePage = MenuItem(
    "Search",
    IconConstants.search,
    IconConstants.searchFilled,
    HomeRoute(),
  );
  static final _playlists = MenuItem(
    "Playlists",
    IconConstants.playlist,
    IconConstants.playlistFilled,
    const PlaylistsTabRoute(),
  );
  static final _likedSongs = MenuItem(
    "Liked songs",
    IconConstants.customHeart,
    IconConstants.customHeartFilled,
    const LikedSongsRoute(),
  );
  static final _spotify = MenuItem(
    "Spotify",
    IconConstants.spotify,
    IconConstants.spotifyFilled,
    const SpotifyRoute(),
  );
  static final _appInfo = MenuItem(
    "Info",
    IconConstants.info,
    IconConstants.infoFilled,
    AppInfoRoute(),
    isVisible: false,
  );

  static final List<MenuItem> menuItems = [_homePage, _playlists, _likedSongs, _spotify, _appInfo];
}
