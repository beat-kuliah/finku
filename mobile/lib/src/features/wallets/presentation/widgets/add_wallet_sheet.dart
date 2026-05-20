import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';

class AddWalletSheet extends ConsumerStatefulWidget {
  const AddWalletSheet({super.key, required this.groups});

  final List<WalletGroupDto> groups;

  @override
  ConsumerState<AddWalletSheet> createState() => _AddWalletSheetState();
}

class _AddWalletSheetState extends ConsumerState<AddWalletSheet> {
  final _nameCtrl = TextEditingController();
  final _newGroupCtrl = TextEditingController();
  String _type = 'cash';
  String? _groupId;
  bool _creatingGroup = false;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _newGroupCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = ref.l10n;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('wallets', 'modal.nameRequired'))),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      var groupId = _groupId;
      if (_creatingGroup) {
        final gname = _newGroupCtrl.text.trim();
        if (gname.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.t('wallets', 'modal.newGroupRequired'))),
          );
          return;
        }
        final g = await ref.read(walletGroupsApiProvider).create(name: gname);
        groupId = g.id;
      }
      await ref.read(walletsApiProvider).create(
            name: name,
            walletType: _type,
            groupId: groupId,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('wallets', 'modal.added'))),
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
      title: w('modal.addTitle'),
      footer: GradientButton(
        onPressed: _saving ? null : _submit,
        child: Text(_saving ? w('saving') : w('save')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
          if (!_creatingGroup)
            DropdownButtonFormField<String?>(
              value: _groupId, // ignore: deprecated_member_use
              decoration: InputDecoration(labelText: w('modal.group')),
              items: [
                DropdownMenuItem(value: null, child: Text(w('modal.noGroup'))),
                ...widget.groups.map(
                  (g) => DropdownMenuItem(value: g.id, child: Text(g.name)),
                ),
                DropdownMenuItem(value: '__new__', child: Text(w('modal.newGroup'))),
              ],
              onChanged: (v) {
                if (v == '__new__') {
                  setState(() {
                    _creatingGroup = true;
                    _groupId = null;
                  });
                } else {
                  setState(() => _groupId = v);
                }
              },
            )
          else
            TextField(
              controller: _newGroupCtrl,
              decoration: InputDecoration(labelText: w('modal.newGroupName')),
            ),
        ],
      ),
    );
  }
}

void showAddWalletSheet(BuildContext context, List<WalletGroupDto> groups) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => AddWalletSheet(groups: groups),
  );
}
