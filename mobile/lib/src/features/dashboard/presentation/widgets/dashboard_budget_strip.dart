import 'package:flutter/material.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

/// Budget tracker list with progress bars and paused badge (mirrors web dashboard).
class DashboardBudgetStrip extends StatelessWidget {
  const DashboardBudgetStrip({
    super.key,
    required this.budgets,
    required this.l10n,
  });

  final List<DashboardBudgetItemDto> budgets;
  final L10nBundle l10n;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    if (budgets.isEmpty) {
      return FinkuEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: l10n.t('dashboard', 'budgetTracker'),
        message: l10n.t('dashboard', 'noBudgets'),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('dashboard', 'budgetTracker'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          ...budgets.map((item) {
            final pct = item.limitAmount > 0
                ? ((item.spent / item.limitAmount) * 100).clamp(0, 100).round()
                : 0;
            final over = item.spent > item.limitAmount;
            final frac = item.limitAmount > 0
                ? (item.spent / item.limitAmount).clamp(0.0, 1.0)
                : 0.0;
            final name = item.categoryName?.trim().isNotEmpty == true
                ? item.categoryName!.trim()
                : item.categoryId;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: scheme.onSurface.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: scheme.onSurface.withValues(alpha: 0.1)),
                ),
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
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: scheme.onSurface,
                            ),
                          ),
                        ),
                        if (item.paused)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: scheme.onSurface.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              l10n.t('dashboard', 'paused').trim(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface.withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        const SizedBox(width: 8),
                        Text(
                          '$pct%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: over ? FinkuColors.danger : FinkuColors.success,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: frac,
                        minHeight: 8,
                        backgroundColor: scheme.onSurface.withValues(alpha: 0.1),
                        color: over ? FinkuColors.danger : scheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        MoneyText(
                          item.spent,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                        Text(
                          ' / ',
                          style: TextStyle(
                            fontSize: 12,
                            color: scheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                        MoneyText(
                          item.limitAmount,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: scheme.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
