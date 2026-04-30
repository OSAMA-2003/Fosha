import 'package:flutter/widgets.dart';

import '../formatting/arabic_indic.dart';

/// Convenience widget to enforce Arabic-Indic digits in display strings.
class ArabicIndicText extends StatelessWidget {
  const ArabicIndicText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      ArabicIndic.digits(data),
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

