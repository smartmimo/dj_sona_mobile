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
  );

  final String text;
  final IconData icon;
  final IconData activeIcon;
  final PageRouteInfo route;
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
    PlaylistsRoute(),
  );
  static final _likedSongs = MenuItem(
    "Liked songs",
    IconConstants.customHeart,
    IconConstants.customHeartFilled,
    const LikedSongsRoute(),
  );

  static final List<MenuItem> menuItems = [_homePage, _playlists, _likedSongs];
}
