import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/presentation/format_idr.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider).valueOrNull;
    final fullName = auth?.user?.name.trim();
    final name = (fullName == null || fullName.isEmpty)
        ? 'Sahabat FinKu'
        : fullName.split(' ').first;

    final asyncDash = ref.watch(dashboardDataProvider);

    return asyncDash.when(
      data: (d) => BranchScaffold(
        title: 'Halo, $name 👋',
        subtitle: 'Beranda',
        children: [
          _SummaryStrip(data: d),
          const SizedBox(height: 16),
          _PeriodCard(data: d),
          const SizedBox(height: 16),
          _LatestSection(latest: d.latestTransactions),
        ],
      ),
      loading: () => BranchScaffold(
        title: 'Halo, $name 👋',
        subtitle: 'Beranda',
        children: const [FinkuListSkeleton(count: 4)],
      ),
      error: (e, _) => BranchScaffold(
        title: 'Halo, $name 👋',
        subtitle: 'Beranda',
        children: [
          FinkuEmptyState(
            icon: Icons.cloud_off_rounded,
            title: 'Gagal memuat beranda',
            message: e is ApiError ? e.message : e.toString(),
          ),
        ],
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  const _SummaryStrip({required this.data});

  final DashboardPayloadDto data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo total',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 6),
          MoneyText(
            data.totalBalance,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MiniStat(
                  label: 'Pemasukan periode',
                  amount: data.periodIncome,
                  positive: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MiniStat(
                  label: 'Pengeluaran periode',
                  amount: data.periodExpense,
                  positive: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.amount,
    required this.positive,
  });

  final String label;
  final int amount;
  final bool positive;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final c = positive ? FinkuColors.success : FinkuColors.danger;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: c.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: c.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          MoneyText(
            amount,
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: c),
          ),
        ],
      ),
    );
  }
}

class _PeriodCard extends StatelessWidget {
  const _PeriodCard({required this.data});

  final DashboardPayloadDto data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Periode ringkasan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '${_fmt(data.periodFrom)} → ${_fmt(data.periodTo)}',
            style: TextStyle(
              fontSize: 13,
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          if (data.dailyTrend.isNotEmpty) ...[
            const SizedBox(height: 14),
            SizedBox(
              height: 96,
              child: Builder(
                builder: (context) {
                  final trend = data.dailyTrend.length <= 7
                      ? data.dailyTrend
                      : data.dailyTrend.sublist(data.dailyTrend.length - 7);
                  final maxV = trend
                      .map((e) => e.expense > e.income ? e.expense : e.income)
                      .fold<int>(1, (a, b) => a > b ? a : b);
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: trend.map((p) {
                      final h = maxV > 0 ? (p.expense / maxV * 72).clamp(4.0, 72.0) : 4.0;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Semantics(
                            label: 'Pengeluaran ${_fmt(p.date)}',
                            value: formatIdr(p.expense),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: h,
                                  decoration: BoxDecoration(
                                    gradient: FinkuColors.gradientNeon,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Batang: pengeluaran 7 hari terakhir (skala relatif)',
              style: TextStyle(fontSize: 11, color: scheme.onSurface.withValues(alpha: 0.55)),
            ),
          ],
        ],
      ),
    );
  }

  String _fmt(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}';
    } catch (_) {
      return iso;
    }
  }
}

class _LatestSection extends StatelessWidget {
  const _LatestSection({required this.latest});

  final List<LatestTransactionItemDto> latest;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    if (latest.isEmpty) {
      return const FinkuEmptyState(
        icon: Icons.receipt_long_rounded,
        title: 'Belum ada aktivitas',
        message: 'Transaksi terbaru akan muncul di sini.',
      );
    }
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aktivitas terbaru',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...latest.take(8).map(
                (t) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Icon(
                        t.kind == 'income'
                            ? Icons.south_west_rounded
                            : (t.kind == 'transfer'
                                ? Icons.swap_horiz_rounded
                                : Icons.north_east_rounded),
                        size: 20,
                        color: scheme.onSurface.withValues(alpha: 0.55),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.description?.trim().isNotEmpty == true
                                  ? t.description!.trim()
                                  : t.category,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: scheme.onSurface,
                              ),
                            ),
                            Text(
                              t.category,
                              style: TextStyle(
                                fontSize: 12,
                                color: scheme.onSurface.withValues(alpha: 0.55),
                              ),
                            ),
                          ],
                        ),
                      ),
                      MoneyText(
                        t.amount,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: t.kind == 'income' ? FinkuColors.success : scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
