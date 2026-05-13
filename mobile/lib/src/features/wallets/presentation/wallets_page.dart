import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
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
    final async = ref.watch(walletsDataProvider);

    return async.when(
      data: (snap) {
        if (snap.wallets.isEmpty) {
          return const BranchScaffold(
            title: 'Dompet',
            subtitle: 'Dompet & rekening',
            children: [
              FinkuEmptyState(
                icon: Icons.account_balance_wallet_rounded,
                title: 'Belum ada dompet',
                message: 'Tambah dompet dari web dulu, atau tunggu fitur tambah dompet di mobile.',
              ),
            ],
          );
        }
        final byGroup = _groupWallets(snap.wallets, snap.groups);
        return BranchScaffold(
          title: 'Dompet',
          subtitle: 'Dompet & rekening',
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
      loading: () => const BranchScaffold(
        title: 'Dompet',
        subtitle: 'Dompet & rekening',
        children: [FinkuListSkeleton(count: 4)],
      ),
      error: (e, _) => BranchScaffold(
        title: 'Dompet',
        subtitle: 'Dompet & rekening',
        children: [
          FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Gagal memuat dompet',
            message: e is ApiError ? e.message : e.toString(),
          ),
        ],
      ),
    );
  }

  Map<String, List<WalletDto>> _groupWallets(List<WalletDto> wallets, List<WalletGroupDto> groups) {
    final nameById = {for (final g in groups) g.id: g.name};
    final map = <String, List<WalletDto>>{};
    for (final w in wallets) {
      final gid = w.groupId;
      final key = (gid != null && gid.isNotEmpty) ? (nameById[gid] ?? 'Grup') : 'Tanpa grup';
      map.putIfAbsent(key, () => []).add(w);
    }
    final ordered = <String, List<WalletDto>>{};
    if (map.containsKey('Tanpa grup')) {
      ordered['Tanpa grup'] = map['Tanpa grup']!;
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
