import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:djsona_mobile/router/app_router.dart';

class DJSonaMobileApp extends StatelessWidget {
  DJSonaMobileApp({super.key});
  final AppRouter appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return _buildAppWidget(context);
  }

  Widget _buildAppWidget(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true, textScaleFactor: 1),
        child: child ?? Container(),
      ),
      routerDelegate: AutoRouterDelegate.declarative(
        appRouter,
        routes: (_) => [const MainRouter()],
      ),
      routeInformationParser: appRouter.defaultRouteParser(),
    );
  }
}
