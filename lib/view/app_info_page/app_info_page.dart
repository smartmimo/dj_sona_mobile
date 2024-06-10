import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/image_utils.dart';
import 'package:djsona_mobile/utils/local_storage_manager.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/appbar_widget.dart';
import 'package:djsona_mobile/view/shared_components/delete_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfoPage extends StatelessWidget {
  AppInfoPage({super.key});
  final AppStateCubit _appStateCubit = serviceLocator.get<AppStateCubit>();
  final LocalStorageManager _localStorageManager = serviceLocator.get<LocalStorageManager>();
  final PackageInfo _packageInfo = serviceLocator.get<PackageInfo>();

  @override
  Widget build(context) {
    return BlocBuilder<AppStateCubit, AppState>(
      bloc: _appStateCubit,
      builder: _mapStateToWidget,
    );
  }

  Widget _mapStateToWidget(BuildContext context, AppState state) {
    return Scaffold(
      backgroundColor: ImageUtils.lightenColor(Theme.of(context).colorScheme.secondary, 0.6),
      resizeToAvoidBottomInset: false,
      appBar: AppBarWidget(
        content: Row(
          children: [
            Text(
              "About DJ Sona",
              style: Theme.of(context).textTheme.bodyXLBold.copyWith(color: ColorConstants.white),
            ),
          ],
        ),
      ),
      body: _getContent(context),
    );
  }

  Widget _getContent(BuildContext context) {
    return Padding(
      padding: StyleConstants.edgeInsets16,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _getAppVersion(context),
          Image.asset("assets/images/dj_sona_icon.png"),
          _getSpaceUsageSection(context),
        ],
      ),
    );
  }

  Widget _getAppVersion(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(IconConstants.version, size: 20, color: ColorConstants.blackish),
        Text(
          "${_packageInfo.appName} ${_packageInfo.version}",
          style: Theme.of(context).textTheme.bodyL.copyWith(color: ColorConstants.blackish),
        ),
      ].withHorizontalElementsSpacing(8),
    );
  }

  Widget _getSpaceUsageSection(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final int usedSpaceByDownloads = _localStorageManager.getCurrentDownloadFolderSize();
    return Column(
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Downloaded songs: ",
                style: textTheme.bodyXLBold.copyWith(color: ColorConstants.blackish),
              ),
              TextSpan(
                text: StringUtils.formatBytes(usedSpaceByDownloads),
                style: textTheme.bodyXL.copyWith(color: ColorConstants.blackish),
              ),
            ],
          ),
        ),
        DeleteButton(
          text: "Clear all space",
          onPressed: () {
            _localStorageManager.clearDownloads();
            _appStateCubit.init();
          },
          isDisabled: usedSpaceByDownloads == 0,
        )
      ].withVerticalElementsSpacing(8),
    );
  }
}
