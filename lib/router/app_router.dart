import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/view/home_page/home_page.dart';
import 'package:djsona_mobile/view/landing_page/landing_page.dart';
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
          ],
        ),
      ],
    ),
  ],
)
class AppRouter extends _$AppRouter {
  AppRouter();
}
