import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class SnackBarWidget extends SnackBar {
  final String text;
  final BuildContext context;

  SnackBarWidget.success({
    super.key,
    required this.context,
    required this.text,
  }) : super(
          content: _getSnackContent(
            context,
            text: text,
            icon: IconConstants.checkCircle,
            textColor: ColorConstants.greenSuccess,
          ),
          behavior: SnackBarBehavior.floating,
          margin: StyleConstants.edgeInsets16,
          backgroundColor: ColorConstants.veryLightGreen,
          shape: RoundedRectangleBorder(borderRadius: StyleConstants.radius8),
          elevation: 1,
        );

  SnackBarWidget.error({
    super.key,
    required this.context,
    required this.text,
  }) : super(
          content: _getSnackContent(
            context,
            text: text,
            icon: IconConstants.alertTriangle,
            textColor: ColorConstants.roofTerracotta,
          ),
          behavior: SnackBarBehavior.floating,
          margin: StyleConstants.edgeInsets16,
          backgroundColor: ColorConstants.peachSchnapps,
          shape: RoundedRectangleBorder(borderRadius: StyleConstants.radius8),
          elevation: 1,
        );

  static Widget _getSnackContent(
    BuildContext context, {
    required String text,
    required IconData icon,
    required Color textColor,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: textColor,
          size: 20,
        ),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyL.copyWith(color: textColor),
          ),
        ),
      ].withHorizontalElementsSpacing(8),
    );
  }
}
