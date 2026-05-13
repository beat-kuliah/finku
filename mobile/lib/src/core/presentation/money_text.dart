import 'package:flutter/material.dart';

import 'package:finku_mobile/src/core/presentation/format_idr.dart';

/// Single place for currency display (IDR, whole rupiah).
class MoneyText extends StatelessWidget {
  const MoneyText(
    this.amount, {
    super.key,
    this.style,
    this.withPrefix = true,
    this.semanticsLabel,
  });

  final num amount;
  final TextStyle? style;
  final bool withPrefix;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    final text = formatIdr(amount, withPrefix: withPrefix);
    return Text(
      text,
      style: style,
      semanticsLabel: semanticsLabel ?? text,
    );
  }
}
