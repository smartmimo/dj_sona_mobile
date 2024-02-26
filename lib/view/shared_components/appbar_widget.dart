import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget({
    super.key,
    this.title,
    this.backgroundColor,
  }) : preferredSize = Size.fromHeight(appbarHeight);

  @override
  final Size preferredSize;
  final String? title;
  final Color? backgroundColor;

  static const double _topBottomPadding = 8;
  static const double _leftPadding = 16;
  static const double _leadingButtonSize = 32;

  static double get leftPadding => _leftPadding;
  static double get topBottomPadding => _topBottomPadding;
  static double get appbarHeight => _leadingButtonSize + (_topBottomPadding * 2);
  static double get leadingWidgetWidth => _leadingButtonSize + _leftPadding;
  static double get leadingIconSize => _leadingButtonSize * .7;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: backgroundColor ?? ColorConstants.bsFlatWhite,
      excludeHeaderSemantics: true,
      centerTitle: true,
      title: _getTitle(context),
      leading: _getAppbarButton(),
      toolbarHeight: appbarHeight,
      leadingWidth: leadingWidgetWidth,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/overlay.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _getTitle(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return Text(
      title ?? "",
      maxLines: 3,
      style: textTheme.heading4.copyWith(color: ColorConstants.blackish),
    );
  }

  Widget _getAppbarButton() {
    return AutoLeadingButton(builder: (context, leadingType, action) {
      return GestureDetector(
        onTap: action,
        child: _getAppbarButtonIcon(leadingType, action),
      );
    });
  }

  Widget _getAppbarButtonIcon(
    LeadingType leadingType,
    void Function()? action,
  ) {
    switch (leadingType) {
      case LeadingType.back:
        return _getBackbutton(action);
      case LeadingType.close:
        throw UnimplementedError();
      case LeadingType.drawer:
        throw UnimplementedError();
      case LeadingType.noLeading:
        return Container();
    }
  }

  Widget _getBackbutton(VoidCallback? action) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        leftPadding,
        topBottomPadding,
        0,
        topBottomPadding,
      ),
      decoration: BoxDecoration(
        color: ColorConstants.springWood,
        boxShadow: StyleConstants.standardShadow,
        borderRadius: StyleConstants.radius8,
      ),
      child: Icon(
        IconConstants.chevronLeft,
        color: ColorConstants.blackish,
        size: leadingIconSize,
      ),
    );
  }
}
