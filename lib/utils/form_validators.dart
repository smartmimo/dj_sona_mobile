import 'package:djsona_mobile/utils/string_utils.dart';

class FormValidators {
  static String? requiredValidator(String? value) {
    if (StringUtils.isEmpty(value)) {
      return "Veuillez remplir ce champ";
    }
    return null;
  }

  static String? emailValidator(String? value) {
    final String? required = requiredValidator(value);
    if (required != null) return required;

    RegExp regExp = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
      caseSensitive: false,
      multiLine: false,
    );

    if (!regExp.hasMatch(value!)) {
      return "Veuillez entrer un mail valide";
    }
    return null;
  }

  static String? numberValidator(String? value) {
    final String? required = requiredValidator(value);
    if (required != null) return required;

    if (int.tryParse(value!) == null) {
      return "Veuillez entrer un nombre valide";
    }
    return null;
  }

  static String? lesserThanValidator(String? value, int limit) {
    final String? validNumber = numberValidator(value);
    if (validNumber != null) return validNumber;

    if (int.parse(value!) > limit) {
      return "Le nombre doît être inférieur ou égal à $limit";
    }
    return null;
  }

  static String? greaterThanValidator(String? value, int limit) {
    final String? validNumber = numberValidator(value);
    if (validNumber != null) return validNumber;

    if (int.parse(value!) <= limit) {
      return "Le nombre doît être supérieur à $limit";
    }
    return null;
  }
}
