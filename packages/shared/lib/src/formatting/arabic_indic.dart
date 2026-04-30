import 'package:intl/intl.dart';

/// Arabic-Indic numerals (٠١٢٣٤٥٦٧٨٩) are mandatory across the UI.
abstract final class ArabicIndic {
  static const _arabicIndicDigits = <String>[
    '٠',
    '١',
    '٢',
    '٣',
    '٤',
    '٥',
    '٦',
    '٧',
    '٨',
    '٩',
  ];

  /// Converts all ASCII digits in [input] into Arabic-Indic digits.
  static String digits(String input) {
    final buffer = StringBuffer();
    for (final rune in input.runes) {
      final char = String.fromCharCode(rune);
      final digit = int.tryParse(char);
      if (digit != null) {
        buffer.write(_arabicIndicDigits[digit]);
      } else {
        buffer.write(char);
      }
    }
    return buffer.toString();
  }

  static String intValue(int value) => digits(value.toString());

  static String moneyEgp(num value) {
    final formatted = NumberFormat.currency(
      locale: 'ar_EG',
      symbol: 'ج.م',
      decimalDigits: 2,
    ).format(value);
    return digits(formatted);
  }
}

