import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';

/// List tile for Profile → Categories (wired in Phase 2).
class CategoriesProfileEntry extends StatelessWidget {
  const CategoriesProfileEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final tokens = FinkuColors.glassTokens(Theme.of(context).brightness);

    return Material(
      color: tokens.fill,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: tokens.border),
      ),
      child: ListTile(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(16))),
        leading: Icon(Icons.category_rounded, color: scheme.primary),
        title: Text(
          l10n.t('profile', 'manageCategories'),
          style: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
        ),
        subtitle: Text(
          l10n.t('profile', 'manageCategoriesHint'),
          style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.6)),
        ),
        trailing: Icon(Icons.chevron_right_rounded, color: scheme.onSurface.withValues(alpha: 0.5)),
        onTap: () => context.push('/categories'),
      ),
    );
  }
}
