import 'dart:ui';

/// Supported app languages (aligned with web `AppLocale`).
enum AppLocale {
  id,
  en;

  static const storageKey = 'finku-locale';

  String get languageCode => name;

  /// BCP 47 tag for `intl` formatters.
  String get bcp47Tag => switch (this) {
        AppLocale.id => 'id_ID',
        AppLocale.en => 'en_US',
      };

  Locale toFlutterLocale() => Locale(languageCode);

  static AppLocale? tryParse(String? raw) => switch (raw) {
        'id' => AppLocale.id,
        'en' => AppLocale.en,
        _ => null,
      };

  /// Device language → app locale when nothing is stored yet.
  static AppLocale detectSystemLocale() {
    final code =
        PlatformDispatcher.instance.locale.languageCode.toLowerCase();
    if (code.startsWith('id')) return AppLocale.id;
    return AppLocale.en;
  }
}
