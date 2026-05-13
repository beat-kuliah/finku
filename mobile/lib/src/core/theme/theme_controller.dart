import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/secure_storage/theme_store.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store_provider.dart';

final themeStoreProvider = Provider<ThemeStore>((ref) {
  return ThemeStore(ref.read(secureStorageProvider));
});

/// Default theme on first launch — matches the FinKu web app default.
const ThemeMode kDefaultThemeMode = ThemeMode.dark;

/// Holds the active [ThemeMode] and persists changes to secure storage.
///
/// The optimistic-render-then-load pattern keeps the first paint synchronous
/// (avoids a flash of system theme) while still hydrating the user's preference
/// in the background.
class ThemeController extends Notifier<ThemeMode> {
  bool _hydrated = false;

  @override
  ThemeMode build() {
    Future.microtask(_hydrate);
    return kDefaultThemeMode;
  }

  Future<void> _hydrate() async {
    if (_hydrated) return;
    _hydrated = true;
    final stored = await ref.read(themeStoreProvider).read();
    if (stored != null && stored != state) {
      state = stored;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    if (state == mode) return;
    state = mode;
    await ref.read(themeStoreProvider).save(mode);
  }

  Future<void> toggle() {
    final next = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    return setMode(next);
  }
}

final themeControllerProvider =
    NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);
