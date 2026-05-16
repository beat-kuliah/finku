import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:intl/intl.dart';

String formatDate(
  DateTime value,
  AppLocale locale, {
  String pattern = 'd MMM y',
}) {
  return DateFormat(pattern, locale.bcp47Tag).format(value);
}

String formatWeekdayShort(DateTime value, AppLocale locale) {
  return DateFormat.E(locale.bcp47Tag).format(value);
}

int localeCompareName(String a, String b, AppLocale locale) {
  return a.toLowerCase().compareTo(b.toLowerCase());
}
