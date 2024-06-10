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

  static String? timeAgo(DateTime? dateTime) {
    if (dateTime == null) return null;

    final now = DateTime.now();
    final difference = now.difference(dateTime);
    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years year${years != 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months != 1 ? 's' : ''} ago';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} day${difference.inDays != 1 ? 's' : ''} ago';
    } else if (difference.inHours >= 1) {
      return '${difference.inHours} hour${difference.inHours != 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  static String viewsToKMBFormat(int number) {
    if (number < 1000) {
      return number.toString();
    } else if (number < 1000000) {
      return '${(number / 1000).toStringAsFixed(0)}K views';
    } else if (number < 1000000000) {
      return '${(number / 1000000).toStringAsFixed(0)}M views';
    } else {
      return '${(number / 1000000000).toStringAsFixed(0)}B views';
    }
  }

  static String prettyDuration(Duration? duration) {
    if (duration == null) return "0:00";
    if (duration.inHours == 0) {
      return "${duration.inMinutes.remainder(60)}:${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    } else {
      return "${duration.inHours}:${duration.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(duration.inSeconds.remainder(60).toString().padLeft(2, '0'))}";
    }
  }

  static String formatBytes(int bytes) {
    const int kB = 1024;
    const int mB = kB * 1024;
    const int gB = mB * 1024;

    if (bytes >= gB) {
      return '${(bytes / gB).toStringAsFixed(2)} GB';
    } else if (bytes >= mB) {
      return '${(bytes / mB).toStringAsFixed(2)} MB';
    } else if (bytes >= kB) {
      return '${(bytes / kB).toStringAsFixed(2)} KB';
    } else {
      return '$bytes bytes';
    }
  }
}
