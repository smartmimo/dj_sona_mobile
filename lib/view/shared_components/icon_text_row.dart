import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class IconTextRow extends StatelessWidget {
  const IconTextRow({
    super.key,
    required this.iconData,
    required this.label,
    required this.value,
    this.isVertical = false,
    this.valueColor = ColorConstants.blackish,
    this.iconSize = 20,
  });

  final IconData iconData;
  final int iconSize;
  final String label;
  final String value;
  final bool isVertical;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Row(
      // crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(iconData, size: 20),
        if (isVertical) ...{
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: textTheme.bodyL.copyWith(color: ColorConstants.blackish),
              ),
              Text(
                value,
                style: textTheme.bodyLBold.copyWith(
                  color: valueColor,
                ),
              ),
            ].withVerticalElementsSpacing(2),
          ),
        } else ...{
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: textTheme.bodyL.copyWith(color: ColorConstants.blackish),
                ),
                TextSpan(
                  text: value,
                  style: textTheme.bodyLBold.copyWith(
                    color: valueColor,
                  ),
                ),
              ],
            ),
          ),
        },
      ].withHorizontalElementsSpacing(4),
    );
  }
}
