import 'package:flutter/material.dart';
import 'package:djsona_mobile/constants/color_constants.dart';
import 'package:djsona_mobile/constants/icon_constants.dart';
import 'package:djsona_mobile/constants/style_constants.dart';
import 'package:djsona_mobile/utils/string_utils.dart';
import 'package:djsona_mobile/utils/theme_utils/elements_spacing_extension.dart';
import 'package:djsona_mobile/utils/theme_utils/text_theme_extension.dart';

class TxtFormField extends StatelessWidget {
  static const double _iconSize = 20;

  BorderRadius get _getBorderRadius => borderRadius ?? StyleConstants.radius12;

  const TxtFormField({
    super.key,
    this.labeltext,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
    this.initialValue,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.textStyle,
    this.labelStyle,
    this.floatingLabelStyle,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.borderRadius,
    this.maxLines = 1,
    this.focusNode,
    this.padding = StyleConstants.edgeInsetsV8H12,
    this.textFieldHeight,
    this.isFilled = true,
    this.crossAxisAlignment,
    this.borderColor = ColorConstants.grey,
    this.autofillHints,
  });

  final String? labeltext;
  final Icon? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final String? initialValue;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? hintText;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? floatingLabelStyle;
  final bool readOnly;
  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final BorderRadius? borderRadius;
  final bool isFilled;
  final int? maxLines;
  final EdgeInsets padding;
  final FocusNode? focusNode;
  final double? textFieldHeight;
  final CrossAxisAlignment? crossAxisAlignment;
  final Color borderColor;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      initialValue: controller != null ? controller!.text : (initialValue ?? ''),
      validator: validator,
      builder: (FormFieldState<String> field) {
        return _getFormField(context, field);
      },
    );
  }

  Widget _getFormField(BuildContext context, FormFieldState<String> field) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: _getBackgroundColor(context),
            border: Border.all(
              color: StringUtils.isNotEmpty(field.errorText) ? ColorConstants.errorText : borderColor,
            ),
            borderRadius: _getBorderRadius,
          ),
          padding: padding,
          height: textFieldHeight,
          child: Row(
            children: [
              if (prefixIcon != null) ...{
                _getPrefixIcon(),
              },
              Expanded(child: _getTextField(context, field)),
              if (suffixIcon != null) ...{
                _getSuffixIcon(),
              },
              if (StringUtils.isNotEmpty(field.errorText)) ...{
                const Icon(
                  IconConstants.alertHexaFilled,
                  color: ColorConstants.errorText,
                  size: _iconSize,
                )
              }
            ].withHorizontalElementsSpacing(12),
          ),
        ),
        if (StringUtils.isNotEmpty(field.errorText)) ...{
          Padding(
            padding: StyleConstants.edgeInsetsH16,
            child: Text(
              field.errorText!,
              style: textTheme.bodyM.copyWith(
                color: ColorConstants.errorText,
              ),
            ),
          ),
        }
      ].withVerticalElementsSpacing(4),
    );
  }

  Widget _getTextField(BuildContext context, FormFieldState<String> field) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return TextField(
      focusNode: focusNode,
      style: _getMainTextStyle(textTheme),
      cursorColor: ColorConstants.grey,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: (value) {
        field.didChange(value);
        if (onChanged != null) {
          onChanged!(value);
        }
      },
      readOnly: readOnly,
      maxLines: maxLines,
      onTap: onTap,
      decoration: InputDecoration(
        isDense: true,
        labelText: labeltext,
        hintText: hintText,
        hintStyle: _getLabelTextStyle(textTheme),
        labelStyle: _getLabelTextStyle(textTheme),
        floatingLabelStyle: _getFloatingLabelStyle(textTheme),
        filled: isFilled,
        fillColor: Colors.transparent,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      autocorrect: false,
      autofillHints: autofillHints,
    );
  }

  TextStyle _getMainTextStyle(TextTheme textTheme) {
    return textStyle ??
        textTheme.bodyLBold.copyWith(
          color: ColorConstants.blackish,
        );
  }

  TextStyle _getLabelTextStyle(TextTheme textTheme) {
    return labelStyle ??
        textTheme.bodyL.copyWith(
          fontSize: 15,
          color: ColorConstants.grey,
        );
  }

  TextStyle _getFloatingLabelStyle(TextTheme textTheme) {
    return floatingLabelStyle ?? textTheme.bodyXL.copyWith(color: ColorConstants.mediumGrey);
  }

  Widget _getPrefixIcon() {
    return IconTheme(
      data: const IconThemeData(
        size: _iconSize,
      ),
      child: prefixIcon!,
    );
  }

  Widget _getSuffixIcon() {
    return IconTheme(
      data: const IconThemeData(
        size: _iconSize,
      ),
      child: suffixIcon!,
    );
  }

  Color _getBackgroundColor(BuildContext context) {
    return isFilled && readOnly ? ColorConstants.grey.withOpacity(0.2) : ColorConstants.white;
  }
}
