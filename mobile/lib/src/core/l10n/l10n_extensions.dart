import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';

extension L10nRef on WidgetRef {
  /// Current translation bundle; rebuilds when locale or load state changes.
  AsyncValue<L10nBundle> get l10nAsync => watch(l10nBundleProvider);

  L10nBundle get l10n => watch(l10nBundleProvider).requireValue;
}

extension L10nContext on BuildContext {
  L10nBundle get l10n =>
      ProviderScope.containerOf(this).read(l10nBundleProvider).requireValue;
}
