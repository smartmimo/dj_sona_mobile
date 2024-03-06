import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/view/home_page/home_page.dart';
import 'package:djsona_mobile/view/landing_page/landing_page.dart';
import 'package:djsona_mobile/view/liked_songs_page/liked_songs_page.dart';
import 'package:djsona_mobile/view/playlists_page/playlists_page.dart';
import 'package:djsona_mobile/view/shared_components/playlist_screen_page.dart';
import 'package:flutter/material.dart';
import 'app_wrapper.dart';

part 'app_router.gr.dart';

@MaterialAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      name: "MainRouter",
      page: AppWrapper,
      children: <AutoRoute>[
        AutoRoute(
          initial: true,
          page: LandingPage,
          children: [
            AutoRoute(page: HomePage, initial: true),
            AutoRoute(
              page: PlaylistsPage,
              children: [
                AutoRoute(page: PlaylistScreenPage),
              ],
            ),
            AutoRoute(page: LikedSongsPage),
          ],
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter();
}
