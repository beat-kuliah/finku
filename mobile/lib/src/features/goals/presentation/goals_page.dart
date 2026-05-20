import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/goals/data/dto/goals_dto.dart';
import 'package:finku_mobile/src/features/goals/presentation/providers/goals_provider.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class GoalsPage extends ConsumerWidget {
  const GoalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    final async = ref.watch(goalsListProvider);

    return BranchScaffold(
      title: l10n.t('goals', 'title'),
      subtitle: l10n.t('goals', 'subtitle'),
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _openCreate(context, ref),
            icon: const Icon(Icons.flag_rounded),
            label: Text(l10n.t('goals', 'createGoal')),
          ),
        ),
        const SizedBox(height: 8),
        async.when(
          data: (goals) {
            if (goals.isEmpty) {
              return FinkuEmptyState(
                icon: Icons.flag_outlined,
                title: l10n.t('goals', 'noGoals'),
                message: l10n.t('goals', 'emptyMessage'),
              );
            }
            return Column(
              children: goals
                  .map(
                    (g) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _GoalCard(goal: g, ref: ref),
                    ),
                  )
                  .toList(),
            );
          },
          loading: () => const FinkuListSkeleton(count: 4),
          error: (e, _) => FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: l10n.t('goals', 'loadFailed'),
            message: e is ApiError ? e.message : e.toString(),
          ),
        ),
      ],
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    DateTime? deadline;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
          title: Text(dialogL10n.t('goals', 'newGoal')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: dialogL10n.t('goals', 'name')),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: dialogL10n.t('goals', 'target'),
                  hintText: '10000000',
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: deadline ?? DateTime.now().add(const Duration(days: 90)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) setLocal(() => deadline = picked);
                },
                child: Text(
                  deadline != null
                      ? '${dialogL10n.t('goals', 'deadline')}: ${deadline!.toIso8601String().substring(0, 10)}'
                      : dialogL10n.t('goals', 'deadline'),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.t('goals', 'cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.t('goals', 'save')),
            ),
          ],
        ),
        );
      },
    );
    if (ok != true) return;
    if (!context.mounted) return;
    final name = nameCtrl.text.trim();
    final t = int.tryParse(targetCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (name.isEmpty || t == null || t <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.t('goals', 'invalidForm'))),
      );
      return;
    }
    final deadlineStr = deadline != null
        ? '${deadline!.year.toString().padLeft(4, '0')}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}'
        : null;
    try {
      await ref.read(goalsApiProvider).create(
            name: name,
            targetAmount: t,
            deadline: deadlineStr,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('goals', 'created'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.ref});

  final GoalDto goal;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final frac = goal.targetAmount > 0
        ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
        : 0.0;
    final pctLabel = goal.progressPct != null
        ? (goal.progressPct! <= 1 ? (goal.progressPct! * 100).round() : goal.progressPct!.round())
        : (frac * 100).round();

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  goal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: scheme.onSurface,
                  ),
                ),
              ),
              Text(
                '$pctLabel%',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: frac,
              minHeight: 8,
              backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              MoneyText(
                goal.currentAmount,
                style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.75)),
              ),
              Text(' / ', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45))),
              MoneyText(
                goal.targetAmount,
                style: TextStyle(fontSize: 13, color: scheme.onSurface.withValues(alpha: 0.75)),
              ),
            ],
          ),
          if (goal.deadline != null && goal.deadline!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              l10n.t('goals', 'deadlineLabel', args: {'date': goal.deadline!}),
              style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.55)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => _contribute(context, ref, goal),
                child: Text(l10n.t('goals', 'addFunds')),
              ),
              TextButton(
                onPressed: () => _openEdit(context, ref, goal),
                child: Text(l10n.t('goals', 'editGoal')),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _confirmDelete(context, ref, goal.id),
                child: Text(
                  l10n.t('wallets', 'delete'),
                  style: TextStyle(color: scheme.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _openEdit(BuildContext context, WidgetRef ref, GoalDto g) async {
    final l10n = context.l10n;
    final nameCtrl = TextEditingController(text: g.name);
    final targetCtrl = TextEditingController(text: g.targetAmount.toString());
    DateTime? deadline;
    if (g.deadline != null && g.deadline!.isNotEmpty) {
      try {
        deadline = DateTime.parse(g.deadline!);
      } catch (_) {}
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return StatefulBuilder(
          builder: (ctx, setLocal) => AlertDialog(
            title: Text(dialogL10n.t('goals', 'editGoal')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: InputDecoration(labelText: dialogL10n.t('goals', 'name')),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: targetCtrl,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: dialogL10n.t('goals', 'target')),
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: deadline ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setLocal(() => deadline = picked);
                  },
                  child: Text(
                    deadline != null
                        ? '${dialogL10n.t('goals', 'deadline')}: ${deadline!.toIso8601String().substring(0, 10)}'
                        : dialogL10n.t('goals', 'deadline'),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(dialogL10n.t('goals', 'cancel'))),
              FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(dialogL10n.t('goals', 'save'))),
            ],
          ),
        );
      },
    );
    if (ok != true) return;
    final name = nameCtrl.text.trim();
    final t = int.tryParse(targetCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (name.isEmpty || t == null || t <= 0) return;
    final deadlineStr = deadline != null
        ? '${deadline!.year.toString().padLeft(4, '0')}-${deadline!.month.toString().padLeft(2, '0')}-${deadline!.day.toString().padLeft(2, '0')}'
        : null;
    try {
      await ref.read(goalsApiProvider).update(
            g.id,
            name: name,
            targetAmount: t,
            deadline: deadlineStr,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('goals', 'updated'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }

  Future<void> _contribute(BuildContext context, WidgetRef ref, GoalDto g) async {
    final l10n = context.l10n;
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return AlertDialog(
          title: Text(dialogL10n.t('goals', 'contributeTitle', args: {'name': g.name})),
          content: TextField(
            controller: ctrl,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: dialogL10n.t('goals', 'contributeAmount')),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.t('goals', 'cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.t('goals', 'contributeAction')),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    final amt = int.tryParse(ctrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (amt == null || amt <= 0) return;
    try {
      await ref.read(goalsApiProvider).contribute(g.id, amt);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('goals', 'fundAdded'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = context.l10n;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        final dialogL10n = ctx.l10n;
        return AlertDialog(
          title: Text(dialogL10n.t('goals', 'deleteTitle')),
          content: Text(dialogL10n.t('goals', 'deleteBody')),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: Text(dialogL10n.t('goals', 'cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(dialogL10n.t('wallets', 'delete')),
            ),
          ],
        );
      },
    );
    if (ok != true) return;
    try {
      await ref.read(goalsApiProvider).delete(id);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.t('goals', 'deleted'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }
}
