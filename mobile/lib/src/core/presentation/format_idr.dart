/// Formats whole rupiah amounts like `Rp 12.345` (id-ID style).
String formatIdr(num amount, {bool withPrefix = true}) {
  final neg = amount < 0;
  final v = amount.abs().round();
  final digits = v.toString();
  final buf = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) {
      buf.write('.');
    }
    buf.write(digits[i]);
  }
  final core = buf.toString();
  final body = neg ? '-$core' : core;
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
