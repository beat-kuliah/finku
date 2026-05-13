import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/stats/presentation/providers/stats_provider.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  static String _monthTitle(DateTime d) {
    const months = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${months[d.month - 1]} ${d.year}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(statsDataProvider);

    return async.when(
      data: (s) => BranchScaffold(
        title: 'Statistik',
        subtitle: 'Insight pengeluaran',
        children: [
          Row(
            children: [
              IconButton(
                tooltip: 'Bulan sebelumnya',
                onPressed: () {
                  final m = ref.read(statsMonthProvider);
                  ref.read(statsMonthProvider.notifier).state = DateTime(m.year, m.month - 1);
                },
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  _monthTitle(ref.watch(statsMonthProvider)),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              IconButton(
                tooltip: 'Bulan berikutnya',
                onPressed: () {
                  final m = ref.read(statsMonthProvider);
                  ref.read(statsMonthProvider.notifier).state = DateTime(m.year, m.month + 1);
                },
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TotalsRow(data: s),
          const SizedBox(height: 16),
          _PeriodLabel(data: s),
          const SizedBox(height: 16),
          if (s.categoryBreakdown.isEmpty)
            const FinkuEmptyState(
              icon: Icons.pie_chart_outline_rounded,
              title: 'Belum ada data',
              message: 'Tambah transaksi untuk melihat breakdown kategori.',
            )
          else
            _CategoryList(items: s.categoryBreakdown),
          const SizedBox(height: 16),
          if (s.weeklyExpense.isNotEmpty) _WeeklyList(items: s.weeklyExpense),
        ],
      ),
      loading: () => const BranchScaffold(
        title: 'Statistik',
        subtitle: 'Insight pengeluaran',
        children: [FinkuListSkeleton(count: 5)],
      ),
      error: (e, _) => BranchScaffold(
        title: 'Statistik',
        subtitle: 'Insight pengeluaran',
        children: [
          FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Gagal memuat statistik',
            message: e is ApiError ? e.message : e.toString(),
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.data});

  final StatsPayloadDto data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pemasukan',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                MoneyText(
                  data.totalIncome,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: FinkuColors.success,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pengeluaran',
                  style: TextStyle(
                    fontSize: 12,
                    color: scheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                MoneyText(
                  data.totalExpense,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: FinkuColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PeriodLabel extends StatelessWidget {
  const _PeriodLabel({required this.data});

  final StatsPayloadDto data;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      'Periode ${_short(data.periodFrom)} – ${_short(data.periodTo)}',
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface.withValues(alpha: 0.65),
      ),
    );
  }

  String _short(String iso) {
    try {
      final d = DateTime.parse(iso).toLocal();
      return '${d.day}/${d.month}/${d.year}';
    } catch (_) {
      return iso;
    }
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.items});

  final List<StatsCategoryBreakdownDto> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxV = items.map((e) => e.value).fold<int>(1, (a, b) => a > b ? a : b);
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Per kategori',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((c) {
            final frac = maxV > 0 ? (c.value / maxV).clamp(0.0, 1.0) : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.archived ? '${c.name} (arsip)' : c.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface,
                          ),
                        ),
                      ),
                      MoneyText(
                        c.value,
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: scheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: frac,
                      minHeight: 6,
                      backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _WeeklyList extends StatelessWidget {
  const _WeeklyList({required this.items});

  final List<WeeklyExpenseDto> items;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pengeluaran per minggu',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...items.map(
            (w) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      w.week,
                      style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.75)),
                    ),
                  ),
                  MoneyText(
                    w.total,
                    style: TextStyle(fontWeight: FontWeight.w700, color: scheme.onSurface),
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
