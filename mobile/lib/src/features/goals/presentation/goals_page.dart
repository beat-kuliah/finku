import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
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
    final async = ref.watch(goalsListProvider);

    return BranchScaffold(
      title: 'Target',
      subtitle: 'Tabungan & mimpi',
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: () => _openCreate(context, ref),
            icon: const Icon(Icons.flag_rounded),
            label: const Text('Target baru'),
          ),
        ),
        const SizedBox(height: 8),
        async.when(
          data: (goals) {
            if (goals.isEmpty) {
              return const FinkuEmptyState(
                icon: Icons.flag_outlined,
                title: 'Belum ada target',
                message: 'Buat target tabungan dan pantau progresnya di sini.',
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
            title: 'Gagal memuat target',
            message: e is ApiError ? e.message : e.toString(),
          ),
        ),
      ],
    );
  }

  Future<void> _openCreate(BuildContext context, WidgetRef ref) async {
    final nameCtrl = TextEditingController();
    final targetCtrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Target baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Nama target'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: targetCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Nominal target (IDR)',
                hintText: '10000000',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Buat')),
        ],
      ),
    );
    if (ok != true) return;
    if (!context.mounted) return;
    final name = nameCtrl.text.trim();
    final t = int.tryParse(targetCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (name.isEmpty || t == null || t <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi nama dan nominal valid.')),
      );
      return;
    }
    try {
      await ref.read(goalsApiProvider).create(name: name, targetAmount: t);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Target dibuat.')));
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
              'Deadline: ${goal.deadline}',
              style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.55)),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => _contribute(context, ref, goal),
                child: const Text('Tambah dana'),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _confirmDelete(context, ref, goal.id),
                child: Text('Hapus', style: TextStyle(color: scheme.error)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _contribute(BuildContext context, WidgetRef ref, GoalDto g) async {
    final ctrl = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Setor ke ${g.name}'),
        content: TextField(
          controller: ctrl,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Jumlah (IDR)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Setor')),
        ],
      ),
    );
    if (ok != true) return;
    final amt = int.tryParse(ctrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (amt == null || amt <= 0) return;
    try {
      await ref.read(goalsApiProvider).contribute(g.id, amt);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Dana ditambahkan.')));
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus target?'),
        content: const Text('Tindakan ini tidak bisa dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hapus')),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(goalsApiProvider).delete(id);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Target dihapus.')));
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
