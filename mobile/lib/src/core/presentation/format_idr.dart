import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:intl/intl.dart';

/// Formats whole rupiah amounts like `Rp 1.234.567` (id) or `Rp 1,234,567` (en).
String formatIdr(
  num amount, {
  bool withPrefix = true,
  AppLocale locale = AppLocale.id,
}) {
  final neg = amount < 0;
  final v = amount.abs().round();
  final formatted = NumberFormat('#,###', locale.bcp47Tag).format(v);
  final body = neg ? '-$formatted' : formatted;
  return withPrefix ? 'Rp $body' : body;
}

/// Parses user input: strips thousand separators, supports comma decimal.
int? parseIdrInput(String raw) {
  final s = raw.trim().replaceAll(RegExp(r'\s'), '');
  if (s.isEmpty) return null;
  final normalized = s.replaceAll('.', '').replaceAll(',', '.');
  final n = double.tryParse(normalized);
  if (n == null || !n.isFinite || n <= 0) return null;
  return n.round();
}
