import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/locale_controller.dart';

/// JSON namespaces mirrored from the web app (excluding `landing`).
///
/// **Ownership convention (Phase 0):** Each namespace JSON file is owned by
/// exactly one feature track. Tracks may freely add or modify keys in their
/// own namespace without coordinating with others.
///
/// `profile.json` is **co-owned**: keys under `categories.*` belong to
/// Track C (Categories management); all other keys belong to Track D
/// (Profile/Auth). Tracks must only add — never remove — keys outside their
/// scope.
const kL10nNamespaces = <String>[
  'common',
  'auth',
  'nav',
  'dashboard',
  'stats',
  'transactions',
  'budget',
  'goals',
  'wallets',
  'profile',
];

/// Loaded translation tables for one [AppLocale].
class L10nBundle {
  L10nBundle._(this.locale, this._namespaces);

  final AppLocale locale;
  final Map<String, Map<String, dynamic>> _namespaces;

  static Future<L10nBundle> load(AppLocale locale) async {
    final namespaces = <String, Map<String, dynamic>>{};
    for (final ns in kL10nNamespaces) {
      final path = 'assets/i18n/${locale.languageCode}/$ns.json';
      final raw = await rootBundle.loadString(path);
      namespaces[ns] = jsonDecode(raw) as Map<String, dynamic>;
    }
    return L10nBundle._(locale, namespaces);
  }

  /// Resolves a dotted key inside a namespace and interpolates `{{name}}`.
  String t(
    String namespace,
    String key, {
    Map<String, String>? args,
  }) {
    final table = _namespaces[namespace];
    if (table == null) return key;

    final value = _resolveKey(table, key);
    if (value == null) return key;
    if (value is! String) return value.toString();

    if (args == null || args.isEmpty) return value;

    var out = value;
    for (final entry in args.entries) {
      out = out.replaceAll('{{${entry.key}}}', entry.value);
    }
    return out;
  }

  static dynamic _resolveKey(Map<String, dynamic> table, String key) {
    final parts = key.split('.');
    dynamic current = table;
    for (final part in parts) {
      if (current is! Map<String, dynamic>) return null;
      current = current[part];
    }
    return current;
  }
}

class L10nBundleNotifier extends AsyncNotifier<L10nBundle> {
  @override
  Future<L10nBundle> build() async {
    final locale = ref.watch(localeControllerProvider);
    return L10nBundle.load(locale);
  }
}

final l10nBundleProvider =
    AsyncNotifierProvider<L10nBundleNotifier, L10nBundle>(
  L10nBundleNotifier.new,
);
