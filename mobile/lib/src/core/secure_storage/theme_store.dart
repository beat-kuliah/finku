import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Persists the user's chosen [ThemeMode] in `flutter_secure_storage`.
class ThemeStore {
  ThemeStore(this._storage);

  static const _themeModeKey = 'app.themeMode';
  final FlutterSecureStorage _storage;

  Future<ThemeMode?> read() async {
    final raw = await _storage.read(key: _themeModeKey);
    return _decode(raw);
  }

  Future<void> save(ThemeMode mode) {
    return _storage.write(key: _themeModeKey, value: _encode(mode));
  }

  Future<void> clear() => _storage.delete(key: _themeModeKey);

  static String _encode(ThemeMode mode) => switch (mode) {
        ThemeMode.dark => 'dark',
        ThemeMode.light => 'light',
        ThemeMode.system => 'system',
      };

  static ThemeMode? _decode(String? raw) => switch (raw) {
        'dark' => ThemeMode.dark,
        'light' => ThemeMode.light,
        'system' => ThemeMode.system,
        _ => null,
      };
}
