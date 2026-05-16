import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';
import 'package:finku_mobile/src/features/wallets/presentation/providers/wallets_provider.dart';

class WalletsPage extends ConsumerWidget {
  const WalletsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final async = ref.watch(walletsDataProvider);

    return async.when(
      data: (snap) {
        if (snap.wallets.isEmpty) {
          return BranchScaffold(
            title: l10n.t('wallets', 'title'),
            subtitle: l10n.t('wallets', 'subtitle'),
            children: [
              FinkuEmptyState(
                icon: Icons.account_balance_wallet_rounded,
                title: l10n.t('wallets', 'noActive'),
                message: l10n.t('wallets', 'emptyHint'),
              ),
            ],
          );
        }
        final byGroup = _groupWallets(snap.wallets, snap.groups, l10n);
        return BranchScaffold(
          title: l10n.t('wallets', 'title'),
          subtitle: l10n.t('wallets', 'subtitle'),
          children: [
            ...byGroup.entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.key,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...e.value.map((w) => Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _WalletTile(wallet: w),
                        )),
                  ],
                ),
              );
            }),
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

  Map<String, List<WalletDto>> _groupWallets(
    List<WalletDto> wallets,
    List<WalletGroupDto> groups,
    L10nBundle l10n,
  ) {
    final ungrouped = l10n.t('wallets', 'ungrouped');
    final groupFallback = l10n.t('wallets', 'groupFallback');
    final nameById = {for (final g in groups) g.id: g.name};
    final map = <String, List<WalletDto>>{};
    for (final w in wallets) {
      final gid = w.groupId;
      final key = (gid != null && gid.isNotEmpty) ? (nameById[gid] ?? groupFallback) : ungrouped;
      map.putIfAbsent(key, () => []).add(w);
    }
    final ordered = <String, List<WalletDto>>{};
    if (map.containsKey(ungrouped)) {
      ordered[ungrouped] = map[ungrouped]!;
    }
    for (final g in groups) {
      if (map.containsKey(g.name)) ordered[g.name] = map[g.name]!;
    }
    for (final e in map.entries) {
      if (!ordered.containsKey(e.key)) ordered[e.key] = e.value;
    }
    return ordered;
  }
}

class _WalletTile extends StatelessWidget {
  const _WalletTile({required this.wallet});

  final WalletDto wallet;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: FinkuColors.gradientNeon,
              borderRadius: BorderRadius.circular(12),
              boxShadow: FinkuColors.neonGlow(opacity: 0.22, blur: 12),
            ),
            alignment: Alignment.center,
            child: Text(
              (wallet.icon?.trim().isNotEmpty == true) ? wallet.icon!.trim() : '💳',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wallet.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  wallet.walletType,
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          MoneyText(
            wallet.balance,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: scheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
