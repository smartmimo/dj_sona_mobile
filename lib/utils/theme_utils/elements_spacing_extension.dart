import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';

extension ElementsSpacing on List<Widget> {
  List<Widget> _wrapWithWidgetAfterEach(Widget widget) {
    List<Widget> result = [];

    for (int index = 0; index < length; index++) {
      result.add(this[index]);
      if (index != length - 1) {
        result.add(widget);
      }
    }
    return result;
  }

  List<Widget> _wrapWithWidgetBeforeEach(Widget widget) {
    List<Widget> result = [];

    for (int index = 0; index < length; index++) {
      result.add(widget);
      result.add(this[index]);
    }
    return result;
  }

  List<Widget> withVerticalElementsSpacing([double spacing = 16]) {
    return _wrapWithWidgetAfterEach(SizedBox(height: spacing));
  }

  List<Widget> withHorizontalElementsSpacing([double spacing = 16]) {
    return _wrapWithWidgetAfterEach(SizedBox(width: spacing));
  }

  List<Widget> wrapWithMargin(EdgeInsets edgeInsets) {
    return map((child) => Container(margin: edgeInsets, child: child)).toList();
  }

  List<Widget> withDivider({
    Widget divider = const Divider(
      height: 1,
      color: ColorConstants.paleGrey01,
    ),
    bool isLastDividerIncluded = true,
    bool isWrapBeforeWidget = false,
    EdgeInsets? padding,
  }) {
    if (padding != null) {
      divider = Padding(
        padding: padding,
        child: divider,
      );
    }
    List<Widget> result = [];
    if (isWrapBeforeWidget) {
      result = _wrapWithWidgetBeforeEach(divider);
    } else {
      result = _wrapWithWidgetAfterEach(divider);
    }

    if (result.isNotEmpty && isLastDividerIncluded) {
      result.add(divider);
    }
    return result;
  }

  List<Widget> wrapWithSliverToBoxAdapter() {
    return List<Widget>.from(
      map(
        (child) => SliverToBoxAdapter(
          child: child,
        ),
      ),
    );
  }
}
