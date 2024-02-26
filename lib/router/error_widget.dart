import 'dart:convert';

import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state.dart';
import 'package:djsona_mobile/cubits/app_state_cubit/app_state_cubit.dart';
import 'package:djsona_mobile/services/service_locator.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';
import 'package:djsona_mobile/view/shared_components/button_master.dart';
import 'package:djsona_mobile/view/shared_components/snack_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ErrorWidget extends StatelessWidget {
  ErrorWidget({
    super.key,
    required this.error,
  });

  final RequestErrorObject error;
  final appStateCubit = serviceLocator.get<AppStateCubit>();

  static const double _infoIconSize = 80;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: StyleConstants.edgeInsetsH16T16,
          child: _getContent(context),
        ),
      ),
    );
  }

  Widget _getContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            _getInfoIcon(context),
            _getTitle(context),
          ].withVerticalElementsSpacing(12),
        ),
        _getDescription(context),
        Column(
          children: [
            _getCopyButton(context),
            _getBackToHomePageButton(context),
          ],
        ),
      ],
    );
  }

  Widget _getInfoIcon(BuildContext context) {
    return Icon(
      IconConstants.info,
      size: _infoIconSize,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _getTitle(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Text(
      "An error has occured",
      style: textTheme.heading3.copyWith(color: Theme.of(context).colorScheme.primary),
    );
  }

  Widget _getDescription(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Flexible(
      child: Container(
        margin: StyleConstants.edgeInsetsV12,
        padding: StyleConstants.edgeInsetsV8H12,
        decoration: BoxDecoration(
          color: ColorConstants.peachSchnapps,
          border: Border.all(
            width: 2,
            color: ColorConstants.roofTerracotta,
          ),
          borderRadius: StyleConstants.radius8,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  error.type.toString(),
                  textAlign: TextAlign.center,
                  style: textTheme.bodyXLBold.copyWith(
                    color: ColorConstants.blackish,
                  ),
                ),
              ),
              if (error.message != null) ...{
                Center(
                  child: Text(
                    error.message!,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyXL.copyWith(
                      color: ColorConstants.blackish,
                    ),
                  ),
                ),
              },
              Padding(
                padding: StyleConstants.edgeInsetsT4,
                child: Text(
                  error.urlAndMethod,
                  style: textTheme.bodyL.copyWith(
                    color: ColorConstants.blackish,
                  ),
                ),
              ),
              if (error.params != null) ...{
                Text(
                  const JsonEncoder.withIndent("     ").convert(error.params),
                  style: textTheme.bodyL.copyWith(
                    color: ColorConstants.blackish,
                  ),
                ),
              },
              if (error.response != null) ...{
                Text(
                  const JsonEncoder.withIndent("     ").convert(error.response),
                  style: textTheme.bodyL.copyWith(
                    color: ColorConstants.blackish,
                  ),
                ),
              }
            ].withVerticalElementsSpacing(4),
          ),
        ),
      ),
    );
  }

  Widget _getBackToHomePageButton(BuildContext context) {
    return Padding(
      padding: StyleConstants.edgeInsetsB16,
      child: ButtonMaster(
        text: "Back to home page",
        onPressed: () => appStateCubit.reset(),
        prefixIcon: const Icon(
          IconConstants.home,
          size: 18,
        ),
      ),
    );
  }

  Widget _getCopyButton(BuildContext context) {
    final textToCopy = '''${error.type}
        ${error.message}
        ${error.urlAndMethod}
        ${error.params != null ? const JsonEncoder.withIndent("     ").convert(error.params) : ''}
        ${error.response != null ? const JsonEncoder.withIndent("     ").convert(error.response) : ''}
        '''
        .split("\n")
        .map((e) => e.trim())
        .join("\n");

    return Padding(
      padding: StyleConstants.edgeInsetsB8,
      child: ButtonMaster.outlined(
        text: "Copy error",
        onPressed: () => Clipboard.setData(
          ClipboardData(text: textToCopy),
        ).then(
          (value) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBarWidget.success(
                context: context,
                text: "Error copied successfully",
              ),
            ),
        ),
        prefixIcon: const Icon(
          IconConstants.document,
          color: ColorConstants.blackish,
          size: 18,
        ),
      ),
    );
  }
}
