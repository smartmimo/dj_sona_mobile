import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';

class PopupDialogLayout extends StatelessWidget {
  const PopupDialogLayout({
    super.key,
    required this.title,
    required this.body,
    this.isDismissible = true,
    this.alignment = Alignment.center,
    this.padding = StyleConstants.edgeInsetsH16B24,
    this.margin = StyleConstants.edgeInsets16,
    this.headerBodySpacing = 16,
  });

  final Widget title;
  final Widget body;
  final Alignment alignment;
  final bool isDismissible;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final double headerBodySpacing;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      alignment: alignment,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      insetPadding: margin,
      elevation: 5,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: StyleConstants.edgeInsetsH16T24,
            child: _getDialogHeader(context),
          ),
          Flexible(
            child: Padding(padding: padding, child: body),
          ),
        ].withVerticalElementsSpacing(headerBodySpacing),
      ),
    );
  }

  Widget _getDialogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title,
        if (isDismissible) _getCloseDialogButton(context),
      ],
    );
  }

  _getCloseDialogButton(BuildContext context) {
    return GestureDetector(
      onTap: _popDialog(context, null),
      child: const Icon(IconConstants.close),
    );
  }

  VoidCallback _popDialog(BuildContext context, result) {
    return () => AutoRouter.of(context).pop(result);
  }
}
