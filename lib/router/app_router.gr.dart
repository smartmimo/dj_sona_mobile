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
      final args = routeData.argsAs<LandingRouteArgs>(orElse: () => const LandingRouteArgs());
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: LandingPage(key: args.key),
      );
    },
    HomeRoute.name: (routeData) {
      return MaterialPageX<dynamic>(
        routeData: routeData,
        child: HomePage(),
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
                )
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
class HomeRoute extends PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '',
        );

  static const String name = 'HomeRoute';
}
