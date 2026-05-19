import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/l10n/locale_controller.dart';
import 'package:finku_mobile/src/core/presentation/format_dates.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/stats/presentation/providers/stats_provider.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

DateTime? _parseIsoDate(String iso) {
  try {
    return DateTime.parse(iso).toLocal();
  } catch (_) {
    return null;
  }
}

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final locale = ref.watch(localeControllerProvider);
    final async = ref.watch(statsDataProvider);
    final month = ref.watch(statsMonthProvider);

    final title = l10n.t('stats', 'title');
    final subtitle = l10n.t('stats', 'subtitle');
    final monthTitle = formatDate(month, locale, pattern: 'MMMM y');

    return async.when(
      data: (s) => BranchScaffold(
        title: title,
        subtitle: subtitle,
        children: [
          Row(
            children: [
              IconButton(
                tooltip: l10n.t('stats', 'prevMonth'),
                onPressed: () {
                  final m = ref.read(statsMonthProvider);
                  ref.read(statsMonthProvider.notifier).state = DateTime(m.year, m.month - 1);
                },
                icon: const Icon(Icons.chevron_left_rounded),
              ),
              Expanded(
                child: Text(
                  monthTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ),
              IconButton(
                tooltip: l10n.t('stats', 'nextMonth'),
                onPressed: () {
                  final m = ref.read(statsMonthProvider);
                  ref.read(statsMonthProvider.notifier).state = DateTime(m.year, m.month + 1);
                },
                icon: const Icon(Icons.chevron_right_rounded),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _TotalsRow(data: s, l10n: l10n),
          const SizedBox(height: 16),
          _PeriodLabel(data: s, l10n: l10n, locale: locale),
          const SizedBox(height: 16),
          if (s.categoryBreakdown.isEmpty)
            FinkuEmptyState(
              icon: Icons.pie_chart_outline_rounded,
              title: l10n.t('stats', 'noData'),
              message: l10n.t('stats', 'emptyBreakdownHint'),
            )
          else
            _CategoryList(items: s.categoryBreakdown, l10n: l10n),
          const SizedBox(height: 16),
          if (s.weeklyExpense.isNotEmpty)
            _WeeklyList(items: s.weeklyExpense, l10n: l10n, locale: locale),
        ],
      ),
      loading: () => BranchScaffold(
        title: title,
        subtitle: subtitle,
        children: const [FinkuListSkeleton(count: 5)],
      ),
      error: (e, _) => BranchScaffold(
        title: title,
        subtitle: subtitle,
        children: [
          FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.t('stats', 'loadFailed'),
            message: e is ApiError ? e.message : e.toString(),
          ),
        ],
      ),
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.data, required this.l10n});

  final StatsPayloadDto data;
  final L10nBundle l10n;

  Widget _metric({
    required BuildContext context,
    required String label,
    required int? amount,
    required Color valueColor,
    String? hint,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: scheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(height: 4),
        if (amount != null)
          MoneyText(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: valueColor,
            ),
          )
        else
          Text(
            '—',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: scheme.onSurface.withValues(alpha: 0.45),
            ),
          ),
        if (hint != null) ...[
          const SizedBox(height: 6),
          Text(
            hint,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final wide = MediaQuery.sizeOf(context).width >= 520;

    final income = _metric(
      context: context,
      label: l10n.t('stats', 'totalIncome'),
      amount: data.totalIncome,
      valueColor: FinkuColors.success,
    );
    final expense = _metric(
      context: context,
      label: l10n.t('stats', 'totalExpense'),
      amount: data.totalExpense,
      valueColor: FinkuColors.danger,
    );
    final modified = _metric(
      context: context,
      label: l10n.t('stats', 'totalModifiedBalance'),
      amount: data.totalModifiedBalance,
      valueColor: scheme.onSurface,
      hint: l10n.t('stats', 'modifiedHint'),
    );

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: wide
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: income),
                Expanded(child: expense),
                Expanded(child: modified),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: income),
                    Expanded(child: expense),
                  ],
                ),
                const SizedBox(height: 14),
                modified,
              ],
            ),
    );
  }
}

class _PeriodLabel extends StatelessWidget {
  const _PeriodLabel({
    required this.data,
    required this.l10n,
    required this.locale,
  });

  final StatsPayloadDto data;
  final L10nBundle l10n;
  final AppLocale locale;

  String _short(String iso) {
    final d = _parseIsoDate(iso);
    if (d == null) return iso;
    return formatDate(d, locale, pattern: 'd/M/y');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Text(
      l10n.t('stats', 'period', args: {
        'from': _short(data.periodFrom),
        'to': _short(data.periodTo),
      }),
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface.withValues(alpha: 0.65),
      ),
    );
  }
}

class _CategoryList extends StatelessWidget {
  const _CategoryList({required this.items, required this.l10n});

  final List<StatsCategoryBreakdownDto> items;
  final L10nBundle l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final maxV = items.map((e) => e.value).fold<int>(1, (a, b) => a > b ? a : b);
    final archivedSuffix = l10n.t('stats', 'archivedSuffix');
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('stats', 'byCategory'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((c) {
            final frac = maxV > 0 ? (c.value / maxV).clamp(0.0, 1.0) : 0.0;
            final name = c.archived ? '${c.name}$archivedSuffix' : c.name;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
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
  const _WeeklyList({
    required this.items,
    required this.l10n,
    required this.locale,
  });

  final List<WeeklyExpenseDto> items;
  final L10nBundle l10n;
  final AppLocale locale;

  String _weekLabel(String week) {
    final d = _parseIsoDate(week.contains('T') ? week : '${week}T12:00:00');
    if (d == null) return week;
    return formatDate(d, locale, pattern: 'd MMM');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('stats', 'weeklyExpense'),
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
                      _weekLabel(w.week),
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
