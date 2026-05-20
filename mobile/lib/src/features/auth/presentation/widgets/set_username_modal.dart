import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

class SetUsernameModal extends ConsumerStatefulWidget {
  const SetUsernameModal({super.key, this.blocking = false});

  final bool blocking;

  @override
  ConsumerState<SetUsernameModal> createState() => _SetUsernameModalState();
}

class _SetUsernameModalState extends ConsumerState<SetUsernameModal> {
  final _ctrl = TextEditingController();
  String? _suggestion;
  bool _loadingSuggestion = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadSuggestion();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadSuggestion() async {
    try {
      final s = await ref.read(authControllerProvider.notifier).suggestUsername();
      if (mounted) {
        setState(() {
          _suggestion = s;
          if (_ctrl.text.isEmpty && s.isNotEmpty) _ctrl.text = s;
          _loadingSuggestion = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _loadingSuggestion = false);
    }
  }

  String? _validate(String value, String Function(String) p) {
    final v = value.trim();
    if (v.isEmpty) return p('usernameModal.required');
    if (v.length < 3) return p('usernameModal.minLength');
    if (v.length > 32) return p('usernameModal.maxLength');
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) return p('usernameModal.invalidChars');
    return null;
  }

  Future<void> _submit() async {
    final l10n = ref.l10n;
    String p(String k) => l10n.t('profile', k);
    final err = _validate(_ctrl.text, p);
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).setUsername(_ctrl.text.trim());
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        if (!widget.blocking) Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(p('usernameModal.saved'))),
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
    String p(String k) => l10n.t('profile', k);
    final scheme = Theme.of(context).colorScheme;

    final content = Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            p('usernameModal.title'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: scheme.onSurface),
          ),
          const SizedBox(height: 8),
          Text(
            p('usernameModal.subtitle'),
            style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.65), height: 1.4),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _ctrl,
            decoration: InputDecoration(
              labelText: p('username'),
              hintText: _loadingSuggestion ? p('usernameModal.placeholderLoading') : p('usernameModal.placeholder'),
            ),
            onChanged: (_) => setState(() {}),
          ),
          if (_suggestion != null && _suggestion!.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => setState(() => _ctrl.text = _suggestion!),
              child: Text('${p('usernameModal.useSuggestion')} $_suggestion'),
            ),
          ],
          const SizedBox(height: 20),
          GradientButton(
            onPressed: _saving ? null : _submit,
            child: Text(_saving ? p('saving') : p('usernameModal.submit')),
          ),
        ],
      ),
    );

    if (widget.blocking) {
      return Material(
        color: scheme.surface,
        child: SafeArea(child: Center(child: SingleChildScrollView(child: content))),
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: content,
    );
  }
}

void showSetUsernameModal(BuildContext context, {bool blocking = false}) {
  if (blocking) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => PopScope(
        canPop: false,
        child: SetUsernameModal(blocking: true),
      ),
    );
  } else {
    showDialog<void>(
      context: context,
      builder: (_) => const SetUsernameModal(),
    );
  }
}
