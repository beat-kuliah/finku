import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/blob_background.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/finku_logo.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(l10nBundleProvider);
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: scheme.surface,
      body: Stack(
        children: [
          const Positioned.fill(child: BlobBackground()),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FinkuLogo(size: FinkuLogoSize.xl),
                const SizedBox(height: 36),
                SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.6,
                    valueColor: AlwaysStoppedAnimation<Color>(FinkuColors.cyan500),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  l10n.t('auth', 'splashPage.loadingSession'),
                  style: TextStyle(
                    fontSize: 13,
                    color: scheme.onSurface.withValues(alpha: 0.65),
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
