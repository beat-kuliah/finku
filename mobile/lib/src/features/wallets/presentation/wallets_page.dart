import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';
import 'package:finku_mobile/src/features/wallets/presentation/providers/wallets_provider.dart';
import 'package:finku_mobile/src/features/wallets/presentation/widgets/add_wallet_sheet.dart';
import 'package:finku_mobile/src/features/wallets/presentation/widgets/adjust_balance_sheet.dart';
import 'package:finku_mobile/src/features/wallets/presentation/widgets/edit_wallet_sheet.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final archived = ref.watch(walletsTabProvider);
    final async = ref.watch(walletsDataProvider);

    return async.when(
      data: (snap) {
        final total = snap.wallets.fold<int>(0, (s, w) => s + w.balance);
        return BranchScaffold(
          title: l10n.t('wallets', 'title'),
          subtitle: l10n.t('wallets', 'subtitle'),
          children: [
            GlassCard(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.t('wallets', 'totalBalance'),
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                    ),
                  ),
                  MoneyText(total, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _TabChip(
                  label: l10n.t('wallets', 'active'),
                  selected: !archived,
                  onTap: () => ref.read(walletsTabProvider.notifier).state = false,
                ),
                const SizedBox(width: 8),
                _TabChip(
                  label: l10n.t('wallets', 'archived'),
                  selected: archived,
                  onTap: () => ref.read(walletsTabProvider.notifier).state = true,
                ),
                const Spacer(),
                if (!archived)
                  TextButton.icon(
                    onPressed: () => showAddWalletSheet(context, snap.groups),
                    icon: const Icon(Icons.add_rounded),
                    label: Text(l10n.t('wallets', 'addWallet')),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            if (snap.wallets.isEmpty)
              FinkuEmptyState(
                icon: Icons.account_balance_wallet_rounded,
                title: archived ? l10n.t('wallets', 'noArchived') : l10n.t('wallets', 'noActive'),
                message: l10n.t('wallets', 'noActive'),
              )
            else if (archived)
              ...snap.wallets.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _WalletTile(wallet: w, archived: true, groups: snap.groups),
                ),
              )
            else
              ..._buildActiveSections(context, ref, snap, l10n),
          ],
        );
      },
      loading: () => BranchScaffold(
        title: l10n.t('wallets', 'title'),
        subtitle: l10n.t('wallets', 'subtitle'),
        children: const [FinkuListSkeleton(count: 4)],
      ),
      error: (e, _) => BranchScaffold(
        title: l10n.t('wallets', 'title'),
        subtitle: l10n.t('wallets', 'subtitle'),
        children: [
          FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.t('wallets', 'loadFailed'),
            message: e is ApiError ? e.message : e.toString(),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActiveSections(
    BuildContext context,
    WidgetRef ref,
    WalletsSnapshot snap,
    L10nBundle l10n,
  ) {
    final byGroup = _groupWallets(snap.wallets, snap.groups, l10n);
    final widgets = <Widget>[];

    for (final g in snap.groups) {
      final list = snap.wallets.where((w) => w.groupId == g.id).toList();
      widgets.add(
        _GroupSection(
          group: g,
          wallets: list,
          allGroups: snap.groups,
          onRenamed: () => ref.invalidate(walletsDataProvider),
        ),
      );
    }

    final ungrouped = snap.wallets.where((w) => w.groupId == null || w.groupId!.isEmpty);
    if (ungrouped.isNotEmpty || snap.groups.isEmpty) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.t('wallets', 'ungrouped'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                ),
              ),
              const SizedBox(height: 8),
              ...ungrouped.map(
                (w) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _WalletTile(wallet: w, archived: false, groups: snap.groups),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (widgets.isEmpty && snap.wallets.isNotEmpty) {
      for (final e in byGroup.entries) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e.key, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...e.value.map(
                  (w) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _WalletTile(wallet: w, archived: false, groups: snap.groups),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    }

    return widgets;
  }

  Map<String, List<WalletDto>> _groupWallets(
    List<WalletDto> wallets,
    List<WalletGroupDto> groups,
    L10nBundle l10n,
  ) {
    final ungrouped = l10n.t('wallets', 'ungrouped');
    final nameById = {for (final g in groups) g.id: g.name};
    final map = <String, List<WalletDto>>{};
    for (final w in wallets) {
      final key = (w.groupId != null && w.groupId!.isNotEmpty)
          ? (nameById[w.groupId] ?? w.groupId!)
          : ungrouped;
      map.putIfAbsent(key, () => []).add(w);
    }
    return map;
  }
}

class _TabChip extends StatelessWidget {
  const _TabChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: scheme.primary.withValues(alpha: 0.2),
    );
  }
}

class _GroupSection extends ConsumerStatefulWidget {
  const _GroupSection({
    required this.group,
    required this.wallets,
    required this.allGroups,
    required this.onRenamed,
  });

  final WalletGroupDto group;
  final List<WalletDto> wallets;
  final List<WalletGroupDto> allGroups;
  final VoidCallback onRenamed;

  @override
  ConsumerState<_GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends ConsumerState<_GroupSection> {
  bool _editing = false;
  late TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.group.name);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _saveRename() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    try {
      await ref.read(walletGroupsApiProvider).update(widget.group.id, name: name);
      ref.read(dataRevisionProvider.notifier).state++;
      widget.onRenamed();
      setState(() => _editing = false);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }

  Future<void> _deleteGroup() async {
    final l10n = ref.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.t('wallets', 'delete')),
        content: Text(
          l10n.t('wallets', 'deleteGroupConfirm', args: {'name': widget.group.name}),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.t('wallets', 'cancel'))),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.t('wallets', 'delete'))),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(walletGroupsApiProvider).delete(widget.group.id);
      ref.read(dataRevisionProvider.notifier).state++;
      widget.onRenamed();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _editing
                    ? TextField(controller: _nameCtrl, autofocus: true)
                    : Text(
                        widget.group.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
              ),
              if (_editing) ...[
                IconButton(onPressed: _saveRename, icon: const Icon(Icons.check_rounded)),
                IconButton(onPressed: () => setState(() => _editing = false), icon: const Icon(Icons.close_rounded)),
              ] else ...[
                TextButton(onPressed: () => setState(() => _editing = true), child: Text(l10n.t('wallets', 'rename'))),
                TextButton(
                  onPressed: _deleteGroup,
                  child: Text(l10n.t('wallets', 'delete'), style: TextStyle(color: scheme.error)),
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          if (widget.wallets.isEmpty)
            Text(l10n.t('wallets', 'noWalletsInGroup'), style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.5)))
          else
            ...widget.wallets.map(
              (w) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _WalletTile(wallet: w, archived: false, groups: widget.allGroups),
              ),
            ),
        ],
      ),
    );
  }
}

class _WalletTile extends ConsumerWidget {
  const _WalletTile({
    required this.wallet,
    required this.archived,
    required this.groups,
  });

  final WalletDto wallet;
  final bool archived;
  final List<WalletGroupDto> groups;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final scheme = Theme.of(context).colorScheme;

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: FinkuColors.gradientNeon,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              (wallet.icon?.trim().isNotEmpty == true) ? wallet.icon!.trim() : '💳',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(wallet.name, style: TextStyle(fontWeight: FontWeight.w800, color: scheme.onSurface)),
                Text(
                  wallet.walletType,
                  style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.55)),
                ),
              ],
            ),
          ),
          MoneyText(wallet.balance, style: TextStyle(fontWeight: FontWeight.w800, color: scheme.onSurface)),
          if (!archived)
            PopupMenuButton<String>(
              onSelected: (v) async {
                switch (v) {
                  case 'edit':
                    showEditWalletSheet(context, wallet: wallet, groups: groups);
                  case 'adjust':
                    showAdjustBalanceSheet(context, wallet);
                  case 'archive':
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.t('wallets', 'archive')),
                        content: Text(l10n.t('wallets', 'archiveConfirm', args: {'name': wallet.name})),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.t('wallets', 'cancel'))),
                          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.t('wallets', 'archive'))),
                        ],
                      ),
                    );
                    if (ok == true) {
                      try {
                        await ref.read(walletsApiProvider).archive(wallet.id);
                        ref.read(dataRevisionProvider.notifier).state++;
                      } catch (e) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(mapDioToApiError(e).message)),
                          );
                        }
                      }
                    }
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(value: 'edit', child: Text(l10n.t('wallets', 'edit'))),
                PopupMenuItem(value: 'adjust', child: Text(l10n.t('wallets', 'adjustBalance'))),
                PopupMenuItem(value: 'archive', child: Text(l10n.t('wallets', 'archive'))),
              ],
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                l10n.t('wallets', 'archivedLabel'),
                style: TextStyle(fontSize: 11, color: scheme.onSurface.withValues(alpha: 0.45)),
              ),
            ),
        ],
      ),
    );
  }
}
