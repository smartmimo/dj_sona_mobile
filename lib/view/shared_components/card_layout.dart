import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';

class CardLayout extends StatelessWidget {
  const CardLayout({
    super.key,
    required this.content,
    this.padding = StyleConstants.edgeInsets16,
    this.hasBorder = false,
  });

  final Widget content;
  final EdgeInsets padding;
  final bool hasBorder;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: StyleConstants.edgeInsetsH16,
      child: Ink(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: StyleConstants.radius8,
          color: ColorConstants.white,
          boxShadow: StyleConstants.standardShadow,
          border: hasBorder
              ? Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignOutside,
                )
              : null,
        ),
        child: content,
      ),
    );
  }
}
