import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await ref.read(authControllerProvider.notifier).login(
            identifier: _identifier.text.trim(),
            password: _password.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      _showError(localizedAuthError(ref, e, AuthErrorScope.login));
    }
  }

  Future<void> _google() async {
    try {
      await ref.read(authControllerProvider.notifier).loginWithGoogle();
      if (mounted) context.go('/dashboard');
    } catch (e) {
      _showError(localizedAuthError(ref, e, AuthErrorScope.google));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(l10nBundleProvider);
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;
    final scheme = Theme.of(context).colorScheme;

    return AuthScaffold(
      title: l10n.t('auth', 'loginPage.title'),
      subtitle: l10n.t('auth', 'loginPage.subtitle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _identifier,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !loading,
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'loginPage.identifierLabel'),
              prefixIcon: const Icon(Icons.alternate_email_rounded, size: 18),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: _password,
            obscureText: !_showPassword,
            textInputAction: TextInputAction.done,
            enabled: !loading,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'loginPage.passwordLabel'),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              suffixIcon: IconButton(
                tooltip: l10n.t('auth', 'loginPage.togglePassword'),
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          GradientButton(
            onPressed: loading ? null : _submit,
            loading: loading,
            child: Text(
              loading
                  ? l10n.t('auth', 'loginPage.submitting')
                  : l10n.t('auth', 'loginPage.submit'),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: Divider(color: scheme.outlineVariant)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l10n.t('auth', 'loginPage.dividerOr'),
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ),
              Expanded(child: Divider(color: scheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: loading ? null : _google,
            icon: const _GoogleGlyph(),
            label: Text(l10n.t('auth', 'loginPage.googleButton')),
          ),
          const SizedBox(height: 14),
          TextButton(
            onPressed: loading ? null : () => context.go('/register'),
            child: Text(
              '${l10n.t('auth', 'loginPage.noAccount')} ${l10n.t('auth', 'loginPage.signUpLink')}',
            ),
          ),
        ],
      ),
    );
  }
}

/// Tiny vector "G" — avoids needing an SVG asset.
class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4285F4), Color(0xFF34A853), Color(0xFFFBBC05), Color(0xFFEA4335)],
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: Text(
        'G',
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          fontSize: 13,
          height: 1.0,
          shadows: [
            Shadow(color: scheme.shadow.withValues(alpha: 0.25), blurRadius: 2),
          ],
        ),
      ),
    );
  }
}
