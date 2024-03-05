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
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LandingPage(),
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
    LikedSongsRoute.name: (routeData) {
      final args = routeData.argsAs<LikedSongsRouteArgs>(
          orElse: () => const LikedSongsRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LikedSongsPage(key: args.key),
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
class LandingRoute extends PageRouteInfo<void> {
  const LandingRoute({List<PageRouteInfo>? children})
      : super(
          LandingRoute.name,
          path: '',
          initialChildren: children,
        );

  static const String name = 'LandingRoute';
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
/// [LikedSongsPage]
class LikedSongsRoute extends PageRouteInfo<LikedSongsRouteArgs> {
  LikedSongsRoute({Key? key})
      : super(
          LikedSongsRoute.name,
          path: 'liked-songs-page',
          args: LikedSongsRouteArgs(key: key),
        );

  static const String name = 'LikedSongsRoute';
}

class LikedSongsRouteArgs {
  const LikedSongsRouteArgs({this.key});

  final Key? key;

  @override
  String toString() {
    return 'LikedSongsRouteArgs{key: $key}';
  }
}
