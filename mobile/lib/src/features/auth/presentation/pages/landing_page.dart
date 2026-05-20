import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/finku_logo.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              const Center(child: FinkuLogo(size: FinkuLogoSize.lg)),
              const SizedBox(height: 28),
              Text(
                l10n.t('auth', 'landing.title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: scheme.onSurface,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.t('auth', 'landing.subtitle'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.45,
                  color: scheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const Spacer(),
              GradientButton(
                onPressed: () => context.go('/login'),
                child: Text(l10n.t('auth', 'landing.signIn')),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => context.go('/register'),
                child: Text(l10n.t('auth', 'landing.signUp')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
