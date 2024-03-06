// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'app_router.dart';

class _$AppRouter extends RootStackRouter {
  _$AppRouter([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    MainRouter.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const AppWrapper(),
      );
    },
    LandingRoute.name: (routeData) {
      final args = routeData.argsAs<LandingRouteArgs>(
          orElse: () => const LandingRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LandingPage(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      final args =
          routeData.argsAs<HomeRouteArgs>(orElse: () => const HomeRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: HomePage(key: args.key),
      );
    },
    PlaylistsRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistsRouteArgs>(
          orElse: () => const PlaylistsRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: PlaylistsPage(key: args.key),
      );
    },
    LikedSongsRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: const LikedSongsPage(),
      );
    },
    PlaylistScreenRoute.name: (routeData) {
      final args = routeData.argsAs<PlaylistScreenRouteArgs>();
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: PlaylistScreenPage(
          key: args.key,
          playlistName: args.playlistName,
        ),
      );
    },
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          MainRouter.name,
          path: '/',
          children: [
            RouteConfig(
              LandingRoute.name,
              path: '',
              parent: MainRouter.name,
              children: [
                RouteConfig(
                  HomeRoute.name,
                  path: '',
                  parent: LandingRoute.name,
                ),
                RouteConfig(
                  PlaylistsRoute.name,
                  path: 'playlists-page',
                  parent: LandingRoute.name,
                  children: [
                    RouteConfig(
                      PlaylistScreenRoute.name,
                      path: 'playlist-screen-page',
                      parent: PlaylistsRoute.name,
                    )
                  ],
                ),
                RouteConfig(
                  LikedSongsRoute.name,
                  path: 'liked-songs-page',
                  parent: LandingRoute.name,
                ),
              ],
            )
          ],
        )
      ];
}

/// generated route for
/// [AppWrapper]
class MainRouter extends PageRouteInfo<void> {
  const MainRouter({List<PageRouteInfo>? children})
      : super(
          MainRouter.name,
          path: '/',
          initialChildren: children,
        );

  static const String name = 'MainRouter';
}

/// generated route for
/// [LandingPage]
class LandingRoute extends PageRouteInfo<LandingRouteArgs> {
  LandingRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          LandingRoute.name,
          path: '',
          args: LandingRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LandingRoute';
}

class LandingRouteArgs {
  const LandingRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LandingRouteArgs{key: $key}';
  }
}

/// generated route for
/// [HomePage]
class HomeRoute extends PageRouteInfo<HomeRouteArgs> {
  HomeRoute({Key? key})
      : super(
          HomeRoute.name,
          path: '',
          args: HomeRouteArgs(key: key),
        );

  static const String name = 'HomeRoute';
}

class HomeRouteArgs {
  const HomeRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key}';
  }
}

/// generated route for
/// [PlaylistsPage]
class PlaylistsRoute extends PageRouteInfo<PlaylistsRouteArgs> {
  PlaylistsRoute({
    Key? key,
    List<PageRouteInfo>? children,
  }) : super(
          PlaylistsRoute.name,
          path: 'playlists-page',
          args: PlaylistsRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'PlaylistsRoute';
}

class PlaylistsRouteArgs {
  const PlaylistsRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'PlaylistsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [LikedSongsPage]
class LikedSongsRoute extends PageRouteInfo<void> {
  const LikedSongsRoute()
      : super(
          LikedSongsRoute.name,
          path: 'liked-songs-page',
        );

  static const String name = 'LikedSongsRoute';
}

/// generated route for
/// [PlaylistScreenPage]
class PlaylistScreenRoute extends PageRouteInfo<PlaylistScreenRouteArgs> {
  PlaylistScreenRoute({
    Key? key,
    required String playlistName,
  }) : super(
          PlaylistScreenRoute.name,
          path: 'playlist-screen-page',
          args: PlaylistScreenRouteArgs(
            key: key,
            playlistName: playlistName,
          ),
        );

  static const String name = 'PlaylistScreenRoute';
}

class PlaylistScreenRouteArgs {
  const PlaylistScreenRouteArgs({
    this.key,
    required this.playlistName,
  });

  final Key? key;

  final String playlistName;

  @override
  String toString() {
    return 'PlaylistScreenRouteArgs{key: $key, playlistName: $playlistName}';
  }
}
