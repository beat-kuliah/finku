import 'package:flutter/material.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

/// Period balance-adjustment mini stat (mirrors web dashboard hero).
class DashboardModifiedStat extends StatelessWidget {
  const DashboardModifiedStat({
    super.key,
    required this.amount,
    required this.l10n,
  });

  final int? amount;
  final L10nBundle l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: scheme.onSurface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: scheme.onSurface.withValues(alpha: 0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('dashboard', 'modifiedPeriod'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          if (amount != null)
            MoneyText(
              amount!,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: scheme.onSurface,
              ),
            )
          else
            Text(
              '—',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: scheme.onSurface.withValues(alpha: 0.45),
              ),
            ),
        ],
      ),
    );
  }
}

/// Estimated budget headroom for the period (sum of per-category remaining).
class DashboardBudgetRemainingStat extends StatelessWidget {
  const DashboardBudgetRemainingStat({
    super.key,
    required this.remaining,
    required this.l10n,
  });

  final int remaining;
  final L10nBundle l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: FinkuColors.cyan500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: FinkuColors.cyan500.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('dashboard', 'budgetRemaining'),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: scheme.onSurface.withValues(alpha: 0.65),
            ),
          ),
          const SizedBox(height: 4),
          MoneyText(
            remaining,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: FinkuColors.cyan500,
            ),
          ),
        ],
      ),
    );
  }
}

int dashboardBudgetRemaining(List<DashboardBudgetItemDto> budgets) {
  return budgets.fold<int>(
    0,
    (sum, b) => sum + (b.limitAmount - b.spent).clamp(0, b.limitAmount),
  );
}
