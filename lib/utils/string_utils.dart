abstract class StringUtils {
  StringUtils._();
  static const String space = " ";
  static const String newLine = "\n";
  static const String ampersand = "&";
  static const String emptyString = "";
  static const String plus = "+";
  static const String plusMinus = "±";
  static const String slash = "/";
  static const String paranthesisLeft = "(";
  static const String paranthesisRight = ")";
  static const String asterisk = "*";
  static const String comma = ",";

  static const String dash = '-';
  static const String longDash = '–';
  static const String colon = ":";
  static const String leftSquareBracket = "[";
  static const String rightSquareBracket = "]";
  static const String xMark = "x";
  static const String zero = "0";
  static const String percent = "%";
  static const String exclamationPoint = "!";
  static const String hashtag = "#";
  static const String at = "@";

  static String defaultString(String? str, {String defaultStr = emptyString}) {
    return str ?? defaultStr;
  }

  static bool equalsIgnoreCase(String str1, String str2) {
    return str1.toLowerCase() == str2.toLowerCase();
  }

  static bool isEmpty(String? str) {
    return str == null || str.isEmpty;
  }

  static bool isNotEmpty(String? str) {
    return !isEmpty(str);
  }

  static bool parseBool(String str) {
    return str.toLowerCase() == "true";
  }

  static String? parseString(dynamic val) {
    if (val != null) {
      return val.toString();
    }
    return null;
  }

  static String capitalizeFirstLetter(String str) {
    if (str.length < 2) {
      return str.toUpperCase();
    }

    return str.substring(0, 1).toUpperCase() + str.substring(1);
  }

  static String capitalizeFirstLetterOfEachWord(String str) {
    if (str.isEmpty) {
      return str;
    }

    return str.split(' ').map((word) {
      if (word.isEmpty) {
        return word;
      }
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  static String? toStringWithoutTrailingZeros(num? num) {
    if (num == null) return null;

    return num.truncateToDouble() == num ? num.toInt().toString() : num.toString();
  }
}
