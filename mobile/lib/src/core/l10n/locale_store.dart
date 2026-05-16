import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the user's language in SharedPreferences (`finku-locale`).
class LocaleStore {
  LocaleStore(this._prefs);

  final SharedPreferences _prefs;

  AppLocale? read() => AppLocale.tryParse(_prefs.getString(AppLocale.storageKey));

  Future<void> save(AppLocale locale) =>
      _prefs.setString(AppLocale.storageKey, locale.languageCode);

  Future<void> clear() => _prefs.remove(AppLocale.storageKey);
}
