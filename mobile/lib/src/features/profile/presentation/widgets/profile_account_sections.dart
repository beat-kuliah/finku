import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/auth/data/dto/auth_dto.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

class ProfileUsernameSection extends ConsumerStatefulWidget {
  const ProfileUsernameSection({super.key, required this.user});

  final AuthUserDto user;

  @override
  ConsumerState<ProfileUsernameSection> createState() => _ProfileUsernameSectionState();
}

class _ProfileUsernameSectionState extends ConsumerState<ProfileUsernameSection> {
  late final TextEditingController _ctrl;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ctrl = TextEditingController(text: widget.user.username ?? '');
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ProfileUsernameSection oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.user.username != widget.user.username) {
      _ctrl.text = widget.user.username ?? '';
    }
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).setUsername(_ctrl.text.trim());
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.l10n.t('profile', 'usernameSaved'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('profile', 'username'), style: _sectionTitle(context)),
        const SizedBox(height: 8),
        TextField(
          controller: _ctrl,
          decoration: InputDecoration(hintText: l10n.t('profile', 'usernamePlaceholder')),
        ),
        const SizedBox(height: 10),
        GradientButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? l10n.t('profile', 'saving') : l10n.t('profile', 'saveUsername')),
        ),
      ],
    );
  }
}

class ProfilePasswordSection extends ConsumerStatefulWidget {
  const ProfilePasswordSection({super.key, required this.hasPassword});

  final bool hasPassword;

  @override
  ConsumerState<ProfilePasswordSection> createState() => _ProfilePasswordSectionState();
}

class _ProfilePasswordSectionState extends ConsumerState<ProfilePasswordSection> {
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _saving = false;
  final bool _show = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = ref.l10n;
    if (_newCtrl.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('profile', 'passwordMinError'))),
      );
      return;
    }
    if (_newCtrl.text != _confirmCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('profile', 'passwordMismatch'))),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).changePassword(
            newPassword: _newCtrl.text,
            confirmNewPassword: _confirmCtrl.text,
            currentPassword: widget.hasPassword ? _currentCtrl.text : null,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      _currentCtrl.clear();
      _newCtrl.clear();
      _confirmCtrl.clear();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('profile', 'passwordSaved'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.t('profile', widget.hasPassword ? 'passwordSection' : 'setPasswordSection'),
          style: _sectionTitle(context),
        ),
        const SizedBox(height: 4),
        Text(
          l10n.t('profile', widget.hasPassword ? 'passwordHintHas' : 'passwordHintNo'),
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 12),
        if (widget.hasPassword)
          TextField(
            controller: _currentCtrl,
            obscureText: !_show,
            decoration: InputDecoration(labelText: l10n.t('profile', 'currentPassword')),
          ),
        if (widget.hasPassword) const SizedBox(height: 10),
        TextField(
          controller: _newCtrl,
          obscureText: !_show,
          decoration: InputDecoration(labelText: l10n.t('profile', 'newPassword')),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _confirmCtrl,
          obscureText: !_show,
          decoration: InputDecoration(labelText: l10n.t('profile', 'confirmPassword')),
        ),
        const SizedBox(height: 10),
        GradientButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? l10n.t('profile', 'saving') : l10n.t('profile', 'savePassword')),
        ),
      ],
    );
  }
}

class ProfileOAuthSection extends ConsumerWidget {
  const ProfileOAuthSection({super.key, required this.user});

  final AuthUserDto user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final providers = user.providers;
    final hasGoogle = providers.contains('google');
    final busy = ref.watch(authControllerProvider).isLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('profile', 'linkedAccounts'), style: _sectionTitle(context)),
        const SizedBox(height: 4),
        Text(
          l10n.t('profile', 'linkedHint'),
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 12),
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.t('profile', 'providerGoogle')),
          subtitle: Text(hasGoogle ? l10n.t('profile', 'connected') : l10n.t('profile', 'notConnected')),
          trailing: hasGoogle
              ? TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(l10n.t('profile', 'unlink')),
                              content: Text(
                                l10n.t('profile', 'unlinkConfirm', args: {'provider': 'Google'}),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.t('common', 'cancel'))),
                                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.t('profile', 'unlink'))),
                              ],
                            ),
                          );
                          if (ok != true) return;
                          try {
                            await ref.read(authControllerProvider.notifier).unlinkProvider('google');
                            ref.read(dataRevisionProvider.notifier).state++;
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(mapDioToApiError(e).message)),
                              );
                            }
                          }
                        },
                  child: Text(l10n.t('profile', 'unlink')),
                )
              : TextButton(
                  onPressed: busy
                      ? null
                      : () async {
                          try {
                            await ref.read(authControllerProvider.notifier).loginWithGoogle();
                            ref.read(dataRevisionProvider.notifier).state++;
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.t('profile', 'googleLinked'))),
                              );
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(localizedAuthError(ref, e, AuthErrorScope.google))),
                              );
                            }
                          }
                        },
                  child: Text(l10n.t('profile', 'link')),
                ),
        ),
      ],
    );
  }
}

class ProfileFinanceSection extends ConsumerStatefulWidget {
  const ProfileFinanceSection({super.key, required this.user});

  final AuthUserDto user;

  @override
  ConsumerState<ProfileFinanceSection> createState() => _ProfileFinanceSectionState();
}

class _ProfileFinanceSectionState extends ConsumerState<ProfileFinanceSection> {
  late final TextEditingController _incomeCtrl;
  late final TextEditingController _paydayCtrl;
  late String _currency;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _incomeCtrl = TextEditingController(
      text: widget.user.monthlyIncome?.toString() ?? '',
    );
    _paydayCtrl = TextEditingController(
      text: widget.user.payday?.toString() ?? '',
    );
    _currency = widget.user.currency;
  }

  @override
  void dispose() {
    _incomeCtrl.dispose();
    _paydayCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final income = int.tryParse(_incomeCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
      final payday = int.tryParse(_paydayCtrl.text.trim());
      await ref.read(authControllerProvider.notifier).updateProfile(
            currency: _currency,
            monthlyIncome: income,
            payday: payday,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.l10n.t('profile', 'saved'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.t('profile', 'financialPrefs'), style: _sectionTitle(context)),
        const SizedBox(height: 4),
        Text(
          l10n.t('profile', 'financialHint'),
          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _incomeCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.t('profile', 'monthlyIncome')),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _paydayCtrl,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: l10n.t('profile', 'payday')),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _currency, // ignore: deprecated_member_use
          decoration: InputDecoration(labelText: l10n.t('profile', 'currency')),
          items: const [
            DropdownMenuItem(value: 'IDR', child: Text('IDR')),
            DropdownMenuItem(value: 'USD', child: Text('USD')),
          ],
          onChanged: (v) => setState(() => _currency = v ?? 'IDR'),
        ),
        const SizedBox(height: 12),
        GradientButton(
          onPressed: _saving ? null : _save,
          child: Text(_saving ? l10n.t('profile', 'saving') : l10n.t('profile', 'save')),
        ),
      ],
    );
  }
}

TextStyle _sectionTitle(BuildContext context) => TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).colorScheme.onSurface,
    );
