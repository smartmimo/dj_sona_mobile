import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class ButtonMaster extends StatelessWidget {
  const ButtonMaster.outlined({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = ColorConstants.blackish,
    this.isDisabled = false,
    this.borderWidth = 2.0,
    this.prefixIcon,
    this.suffixIcon,
    this.filledColor,
    this.isSecondary = false,
    this.isLoading = false,
    this.textStyle,
    this.iconSpacing = 10,
  }) : filled = false;

  const ButtonMaster({
    super.key,
    required this.text,
    required this.onPressed,
    this.textColor = ColorConstants.white,
    this.filledColor,
    this.isDisabled = false,
    this.borderWidth = 2.0,
    this.prefixIcon,
    this.suffixIcon,
    this.isSecondary = false,
    this.isLoading = false,
    this.textStyle,
    this.iconSpacing = 10,
  }) : filled = true;

  final String text;
  final void Function() onPressed;
  final bool filled;
  final Color textColor;
  final TextStyle? textStyle;
  final Color? filledColor;
  final bool isDisabled;
  final double borderWidth;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool isSecondary;
  final bool isLoading;
  final double iconSpacing;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isSecondary ? 36 : 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isDisabled ? null : onPressed,
        style: ButtonStyle(
          backgroundColor: _getBackgroundColor(context),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              side: _getBorderSide(context),
              borderRadius: StyleConstants.radius80,
            ),
          ),
          elevation: MaterialStateProperty.all<double>(0),
          overlayColor: MaterialStateProperty.all<Color>(_getOverlayColor(context)),
          padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
        ),
        child: isLoading ? _getCircularProgressIndicator() : _getButtonContent(context),
      ),
    );
  }

  BorderSide _getBorderSide(BuildContext context) {
    if (filled) {
      return BorderSide.none;
    } else {
      return BorderSide(
        width: borderWidth,
        color: filledColor ?? ColorConstants.primary,
      );
    }
  }

  _getCircularProgressIndicator() {
    return SizedBox(
      height: 28,
      width: 28,
      child: CircularProgressIndicator(
          valueColor: filled
              ? const AlwaysStoppedAnimation<Color>(ColorConstants.white)
              : const AlwaysStoppedAnimation<Color>(ColorConstants.blackish)),
    );
  }

  _getButtonContent(BuildContext context) {
    final Text textWidget = Text(
      text.toUpperCase(),
      style: textStyle ?? _getTextStyle(context),
      textAlign: TextAlign.center,
    );
    if (prefixIcon == null && suffixIcon == null) {
      return textWidget;
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (prefixIcon != null) prefixIcon!,
          textWidget,
          if (suffixIcon != null) suffixIcon!,
        ].withHorizontalElementsSpacing(iconSpacing),
      );
    }
  }

  TextStyle _getTextStyle(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    TextStyle style = textTheme.bodyLBold.copyWith(
      color: textColor,
      letterSpacing: 0.5,
    );
    return style;
  }

  MaterialStateProperty<Color> _getBackgroundColor(BuildContext context) {
    if (filled) {
      return _getFilledColor(context);
    } else {
      return _getTransparentColor();
    }
  }

  MaterialStateProperty<Color> _getFilledColor(BuildContext context) {
    Color color = filledColor ?? ColorConstants.primary;
    return MaterialStateProperty.resolveWith<Color>((buttonState) {
      bool isDisabled = buttonState.contains(MaterialState.disabled);
      if (isDisabled) {
        return color.withOpacity(.4);
      } else {
        return color;
      }
    });
  }

  MaterialStateProperty<Color> _getTransparentColor() {
    return MaterialStateProperty.all<Color>(Colors.transparent);
  }

  Color _getOverlayColor(BuildContext context) {
    if (filled) {
      return ColorConstants.white.withOpacity(0.1);
    } else {
      return ColorConstants.blackish.withOpacity(0.1);
    }
  }
}
