import 'package:djsona_mobile/view/landing_page/audio_player_opener.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/view/landing_page/menu_items_manager.dart';
import 'package:djsona_mobile/view/shared_components/system_overlay_style.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});
  static const double bottomBarHeight = 60;

  @override
  Widget build(context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SystemOverlayStyle.semiDark(
      child: AutoTabsScaffold(
        resizeToAvoidBottomInset: false,
        routes: List<PageRouteInfo>.from(
          MenuItemsManager.menuItems.map((item) => item.route),
        ),
        builder: (context, child, _) {
          return Container(
            color: ColorConstants.background,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(child: child),
                const AudioPlayerOpener(),
              ],
            ),
          );
        },
        bottomNavigationBuilder: (_, tabsRouter) {
          return WillPopScope(
            onWillPop: () async {
              tabsRouter.setActiveIndex(0);
              return false;
            },
            child: Container(
              height: bottomBarHeight,
              color: ColorConstants.primary,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List<Widget>.from(
                  MenuItemsManager.menuItems.map(
                    (item) => _getMenuItem(
                      textTheme,
                      tabsRouter,
                      MenuItemsManager.menuItems.indexOf(item),
                      text: item.text,
                      icon: item.icon,
                      activeIcon: item.activeIcon,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getMenuItem(
    TextTheme textTheme,
    TabsRouter tabsRouter,
    int index, {
    required String text,
    required IconData icon,
    required IconData activeIcon,
  }) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
          elevation: MaterialStateProperty.all<double>(0),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(),
          ),
          overlayColor: MaterialStateProperty.all<Color>(ColorConstants.blackish.withOpacity(0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tabsRouter.activeIndex == index ? Icon(activeIcon) : Icon(icon),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onPressed: () => tabsRouter.setActiveIndex(index),
      ),
    );
  }
}
