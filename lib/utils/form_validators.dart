import 'package:djsona_mobile/utils/string_utils.dart';

class FormValidators {
  static String? requiredValidator(String? value) {
    if (StringUtils.isEmpty(value)) {
      return "Please don't leave this empty";
    }
    return null;
  }

  static String? isValidFilename(String? value) {
    final String? required = requiredValidator(value);
    if (required != null) return required;

    RegExp regExp = RegExp(
      r'[<>:"/\\|?*]',
      caseSensitive: false,
    );

    if (regExp.hasMatch(value!)) {
      return "Special characters are not supported";
    }
    return null;
  }
}
