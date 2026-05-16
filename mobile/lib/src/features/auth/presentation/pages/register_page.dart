import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _showPassword = false;

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await ref.read(authControllerProvider.notifier).register(
            name: _name.text.trim(),
            username: _username.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );
      if (mounted) context.go('/dashboard');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizedAuthError(ref, e, AuthErrorScope.register)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(l10nBundleProvider);
    final l10n = context.l10n;
    final loading = ref.watch(authControllerProvider).isLoading;

    return AuthScaffold(
      title: l10n.t('auth', 'registerPage.title'),
      subtitle: l10n.t('auth', 'registerPage.subtitle'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _name,
            textInputAction: TextInputAction.next,
            enabled: !loading,
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'registerPage.nameLabel'),
              prefixIcon: const Icon(Icons.badge_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _username,
            textInputAction: TextInputAction.next,
            enabled: !loading,
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'registerPage.usernameLabel'),
              prefixIcon: const Icon(Icons.alternate_email_rounded, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            enabled: !loading,
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'registerPage.emailLabel'),
              prefixIcon: const Icon(Icons.email_outlined, size: 18),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            obscureText: !_showPassword,
            textInputAction: TextInputAction.done,
            enabled: !loading,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: l10n.t('auth', 'registerPage.passwordLabel'),
              prefixIcon: const Icon(Icons.lock_outline_rounded, size: 18),
              suffixIcon: IconButton(
                tooltip: l10n.t('auth', 'registerPage.togglePassword'),
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
                  ? l10n.t('auth', 'registerPage.submitting')
                  : l10n.t('auth', 'registerPage.submit'),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: loading ? null : () => context.go('/login'),
            child: Text(
              '${l10n.t('auth', 'registerPage.hasAccount')} ${l10n.t('auth', 'registerPage.loginLink')}',
            ),
          ),
        ],
      ),
    );
  }
}
