import 'package:flutter/material.dart';

extension TextThemeExtension on TextTheme {
  TextStyle get heading1 => const TextStyle(fontSize: 40, fontWeight: FontWeight.w800);
  TextStyle get heading2 => const TextStyle(fontSize: 32, fontWeight: FontWeight.w800);
  TextStyle get heading3 => const TextStyle(fontSize: 24, fontWeight: FontWeight.w800);
  TextStyle get heading4 => const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: 0.4);
  TextStyle get heading5 => const TextStyle(fontSize: 16, fontWeight: FontWeight.w800);
  TextStyle get heading6 => const TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
  TextStyle get heading7 => const TextStyle(fontSize: 8, fontWeight: FontWeight.w800);
  TextStyle get subtitle3 => const TextStyle(fontSize: 12, fontWeight: FontWeight.w800);
  TextStyle get bodyXL => const TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  TextStyle get bodyXLBold => const TextStyle(fontSize: 16, fontWeight: FontWeight.w700);
  TextStyle get bodyL => const TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  TextStyle get bodyLBold => const TextStyle(fontSize: 14, fontWeight: FontWeight.w700);
  TextStyle get bodyM => const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  TextStyle get bodyMBold => const TextStyle(fontSize: 12, fontWeight: FontWeight.w700);
  TextStyle get bodyS => const TextStyle(fontSize: 10, fontWeight: FontWeight.w400);
  TextStyle get bodySBold => const TextStyle(fontSize: 10, fontWeight: FontWeight.w700);
  TextStyle get buttonL => const TextStyle(fontSize: 18, fontWeight: FontWeight.w800);
  TextStyle get buttonS => const TextStyle(fontSize: 14, fontWeight: FontWeight.w800);
  TextStyle get label1 => const TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
}
