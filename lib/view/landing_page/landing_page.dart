import 'package:audio_service/audio_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/audio_player_service.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/landing_page/audio_player_opener.dart';
import 'package:flutter/material.dart';

import 'package:auto_route/auto_route.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/view/landing_page/menu_items_manager.dart';
import 'package:djsona_mobile/view/shared_components/system_overlay_style.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LandingPage extends StatelessWidget {
  LandingPage({super.key});
  static const double bottomBarHeight = 60;

  final AudioPlayerService _audioPlayerService = serviceLocator.get<AudioPlayerService>();
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();

  @override
  Widget build(context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SystemOverlayStyle.semiDark(
      color: Theme.of(context).colorScheme.primary,
      child: AutoTabsScaffold(
        resizeToAvoidBottomInset: false,
        routes: List<PageRouteInfo>.from(
          MenuItemsManager.menuItems.map((item) => item.route),
        ),
        builder: (context, child, _) {
          return Container(
            color: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      child,
                      Positioned(
                        bottom: 4,
                        left: 4,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _getCurrentPlaylistSticker(context),
                            _getQueueItemsSticker(context),
                          ].withVerticalElementsSpacing(2),
                        ),
                      ),
                      Positioned(
                        bottom: 4,
                        right: 4,
                        child: _getCurrentConnectivity(context),
                      ),
                    ],
                  ),
                ),
                AudioPlayerOpener(),
              ],
            ),
          );
        },
        bottomNavigationBuilder: (_, tabsRouter) {
          return PopScope(
            canPop: false,
            onPopInvokedWithResult: (_, __) async {
              tabsRouter.setActiveIndex(0);
            },
            child: Container(
              height: bottomBarHeight,
              color: Theme.of(context).colorScheme.primary,
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
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          elevation: WidgetStateProperty.all<double>(0),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            const RoundedRectangleBorder(),
          ),
          overlayColor: WidgetStateProperty.all<Color>(ColorConstants.blackish.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tabsRouter.activeIndex == index
                ? Icon(activeIcon, color: ColorConstants.white)
                : Icon(icon, color: ColorConstants.white),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(
                  height: 1.5,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: ColorConstants.white,
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

  Container _getCurrentPlaylistSticker(BuildContext context) {
    final item = _audioPlayerService.mediaItem;
    if (item.value == null || StringUtils.isEmpty(item.value!.artist)) return Container();
    return Container(
      alignment: Alignment.center,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: StyleConstants.radius4,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        boxShadow: StyleConstants.standardShadow,
      ),
      padding: StyleConstants.edgeInsetsH8,
      child: Text(
        item.value!.artist!,
        style: Theme.of(context).textTheme.bodyS.copyWith(
              color: ColorConstants.white,
              height: 1,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Container _getQueueItemsSticker(BuildContext context) {
    final List<MediaItem> queue = _audioPlayerService.queue.value;
    return Container(
      alignment: Alignment.center,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: StyleConstants.radius4,
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.9),
        boxShadow: StyleConstants.standardShadow,
      ),
      padding: StyleConstants.edgeInsetsH8,
      child: Text(
        "Queue: ${queue.length} items",
        style: Theme.of(context).textTheme.bodyS.copyWith(
              color: ColorConstants.white,
              height: 1,
            ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _getCurrentConnectivity(BuildContext context) {
    return BlocBuilder<AppStateCubit, AppState>(
      bloc: _appStateCubit,
      builder: (context, state) {
        if (state.connectivityResult == ConnectivityResult.none) {
          return Container(
            alignment: Alignment.center,
            height: 20,
            decoration: BoxDecoration(
              borderRadius: StyleConstants.radius4,
              color: ColorConstants.roofTerracotta,
              boxShadow: StyleConstants.standardShadow,
            ),
            padding: StyleConstants.edgeInsetsH8V4,
            child: Row(
              children: [
                const Icon(IconConstants.noNetwork, color: ColorConstants.white, size: 12),
                Text(
                  "Offline mode",
                  style: Theme.of(context).textTheme.bodyS.copyWith(
                        color: ColorConstants.white,
                        letterSpacing: 0.3,
                        height: 1,
                      ),
                  textAlign: TextAlign.center,
                ),
              ].withHorizontalElementsSpacing(4),
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
