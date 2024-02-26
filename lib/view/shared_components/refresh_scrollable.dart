import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/view/shared_components/button_master.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class RefreshScrollable extends StatelessWidget {
  final List<Widget> items;
  final String emptyItemsMessage;
  final Future<void> Function() refreshContent;
  final double verticalSpacing;
  final GlobalKey<RefreshIndicatorState>? refreshWidgetKey;

  const RefreshScrollable({
    required this.items,
    required this.emptyItemsMessage,
    required this.refreshContent,
    this.verticalSpacing = 0,
    this.refreshWidgetKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    if (items.isEmpty) {
      return Padding(
        padding: StyleConstants.edgeInsets16,
        child: Column(
          children: [
            const Icon(
              IconConstants.crossCircle,
              size: 100,
              color: ColorConstants.roofTerracotta,
            ),
            Text(
              emptyItemsMessage,
              style: textTheme.bodyLBold.copyWith(color: ColorConstants.blackish, height: 1.1),
            ),
            ButtonMaster(text: "Recharger", onPressed: refreshContent),
          ].withVerticalElementsSpacing(24),
        ),
      );
    }

    return RefreshIndicator(
      key: refreshWidgetKey,
      color: Theme.of(context).colorScheme.primary,
      onRefresh: refreshContent,
      strokeWidth: 3,
      child: ListView.builder(
        padding: EdgeInsets.only(top: verticalSpacing / 2),
        itemBuilder: ((context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: verticalSpacing),
            child: items[index],
          );
        }),
        itemCount: items.length,
        physics: const AlwaysScrollableScrollPhysics(),
      ),
    );
  }
}
