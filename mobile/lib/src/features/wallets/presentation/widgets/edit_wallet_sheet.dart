import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

class EditWalletSheet extends ConsumerStatefulWidget {
  const EditWalletSheet({super.key, required this.wallet, required this.groups});

  final WalletDto wallet;
  final List<WalletGroupDto> groups;

  @override
  ConsumerState<EditWalletSheet> createState() => _EditWalletSheetState();
}

class _EditWalletSheetState extends ConsumerState<EditWalletSheet> {
  late final TextEditingController _nameCtrl;
  late String _type;
  late String? _groupId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.wallet.name);
    _type = widget.wallet.walletType;
    _groupId = widget.wallet.groupId;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = ref.l10n;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      await ref.read(walletsApiProvider).update(
            widget.wallet.id,
            name: name,
            walletType: _type,
            groupId: _groupId,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('wallets', 'modal.updated'))),
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
    String w(String k) => l10n.t('wallets', k);

    return FinkuPrimarySheet(
      title: w('modal.editTitle'),
      footer: GradientButton(
        onPressed: _saving ? null : _submit,
        child: Text(_saving ? w('saving') : w('modal.saveChanges')),
      ),
      child: Column(
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: w('modal.name')),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _type, // ignore: deprecated_member_use
            decoration: InputDecoration(labelText: w('modal.type')),
            items: [
              DropdownMenuItem(value: 'cash', child: Text(w('modal.typeCash'))),
              DropdownMenuItem(value: 'bank', child: Text(w('modal.typeBank'))),
              DropdownMenuItem(value: 'ewallet', child: Text(w('modal.typeEwallet'))),
            ],
            onChanged: (v) => setState(() => _type = v ?? 'cash'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            value: _groupId, // ignore: deprecated_member_use
            decoration: InputDecoration(labelText: w('modal.group')),
            items: [
              DropdownMenuItem(value: null, child: Text(w('modal.noGroup'))),
              ...widget.groups.map(
                (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
              ),
            ],
            onChanged: (v) => setState(() => _groupId = v),
          ),
        ],
      ),
    );
  }
}

void showEditWalletSheet(
  BuildContext context, {
  required WalletDto wallet,
  required List<WalletGroupDto> groups,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => EditWalletSheet(wallet: wallet, groups: groups),
  );
}
