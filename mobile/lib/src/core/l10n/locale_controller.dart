import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/locale_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Overridden in [main] with a preloaded instance.
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError(
    'sharedPreferencesProvider must be overridden in main()',
  );
});

final localeStoreProvider = Provider<LocaleStore>((ref) {
  return LocaleStore(ref.watch(sharedPreferencesProvider));
});

/// Default locale on first launch — matches the FinKu web app default.
const AppLocale kDefaultAppLocale = AppLocale.id;

/// Holds the active [AppLocale] and persists changes to SharedPreferences.
class LocaleController extends Notifier<AppLocale> {
  bool _hydrated = false;

  @override
  AppLocale build() {
    Future.microtask(_hydrate);
    return kDefaultAppLocale;
  }

  Future<void> _hydrate() async {
    if (_hydrated) return;
    _hydrated = true;

    final store = ref.read(localeStoreProvider);
    final stored = store.read();
    if (stored != null) {
      if (stored != state) state = stored;
      return;
    }

    final detected = AppLocale.detectSystemLocale();
    if (detected != state) state = detected;
  }

  Future<void> setLocale(AppLocale locale) async {
    if (state == locale) return;
    state = locale;
    await ref.read(localeStoreProvider).save(locale);
  }
}

final localeControllerProvider =
    NotifierProvider<LocaleController, AppLocale>(LocaleController.new);
