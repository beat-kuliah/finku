import 'package:flutter/material.dart';

import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

/// Category breakdown list with progress bars (same pattern as Stats page).
class DashboardCategorySection extends StatelessWidget {
  const DashboardCategorySection({
    super.key,
    required this.items,
    required this.l10n,
  });

  final List<CategoryBreakdownItemDto> items;
  final L10nBundle l10n;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return FinkuEmptyState(
        icon: Icons.pie_chart_outline_rounded,
        title: l10n.t('dashboard', 'categories'),
        message: l10n.t('dashboard', 'noCategoryData'),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final maxV = items.map((e) => e.value).fold<int>(1, (a, b) => a > b ? a : b);
    final archivedSuffix = l10n.t('stats', 'archivedSuffix');

    return GlassCard(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.t('dashboard', 'categories'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.t('dashboard', 'categoryShare'),
            style: TextStyle(
              fontSize: 12,
              color: scheme.onSurface.withValues(alpha: 0.6),
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
