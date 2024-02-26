import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemOverlayStyle extends StatelessWidget implements PreferredSizeWidget {
  const SystemOverlayStyle({
    super.key,
    this.statusBarColor,
    this.systemNavigationBarColor,
    required this.statusBarBrightness,
    required this.systemNavigationBarIconBrightness,
    required this.child,
    required this.color,
  });

  const SystemOverlayStyle.light({
    super.key,
    required this.child,
    required this.color,
  })  : statusBarColor = Colors.transparent,
        systemNavigationBarColor = Colors.transparent,
        statusBarBrightness = Brightness.light,
        systemNavigationBarIconBrightness = Brightness.light;

  const SystemOverlayStyle.dark({
    super.key,
    required this.child,
    required this.color,
  })  : statusBarColor = Colors.transparent,
        systemNavigationBarColor = Colors.transparent,
        statusBarBrightness = Brightness.dark,
        systemNavigationBarIconBrightness = Brightness.dark;

  const SystemOverlayStyle.semiDark({
    super.key,
    required this.child,
    required this.color,
  })  : statusBarColor = Colors.transparent,
        systemNavigationBarColor = color,
        statusBarBrightness = Brightness.dark,
        systemNavigationBarIconBrightness = Brightness.light;

  final Color? statusBarColor;
  final Color? systemNavigationBarColor;
  final Brightness statusBarBrightness;
  final Brightness systemNavigationBarIconBrightness;
  final Widget child;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: statusBarBrightness,
        systemNavigationBarIconBrightness: systemNavigationBarIconBrightness,
        statusBarColor: statusBarColor,
        statusBarIconBrightness: statusBarBrightness,
        systemNavigationBarColor: systemNavigationBarColor,
        systemNavigationBarContrastEnforced: false,
        systemNavigationBarDividerColor: systemNavigationBarColor,
      ),
      child: child,
    );
  }

  @override
  Size get preferredSize => const Size(0.0, 0.0);
}
