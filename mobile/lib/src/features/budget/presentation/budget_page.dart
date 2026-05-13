import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/budget/data/dto/budgets_dto.dart';
import 'package:finku_mobile/src/features/budget/presentation/providers/budget_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';

class BudgetPage extends ConsumerWidget {
  const BudgetPage({super.key});

  String _anchorFirstDay(DateTime m) {
    final d = DateTime(m.year, m.month, 1);
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = ref.watch(budgetMonthProvider);
    final budgets = ref.watch(budgetsListProvider);
    final cats = ref.watch(expenseCategoriesProvider);

    return BranchScaffold(
      title: 'Budget',
      subtitle: 'Pagu pengeluaran',
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Bulan sebelumnya',
              onPressed: () {
                ref.read(budgetMonthProvider.notifier).state =
                    DateTime(month.year, month.month - 1);
              },
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            Expanded(
              child: Text(
                '${_monthLabel(month)} ${month.year}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            IconButton(
              tooltip: 'Bulan berikutnya',
              onPressed: () {
                ref.read(budgetMonthProvider.notifier).state =
                    DateTime(month.year, month.month + 1);
              },
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton.icon(
            onPressed: cats.isLoading
                ? null
                : () => _openAdd(context, ref, month, cats.valueOrNull ?? const []),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah budget'),
          ),
        ),
        const SizedBox(height: 8),
        budgets.when(
          data: (items) {
            if (items.isEmpty) {
              return const FinkuEmptyState(
                icon: Icons.savings_rounded,
                title: 'Belum ada budget',
                message: 'Atur pagu per kategori pengeluaran untuk bulan ini.',
              );
            }
            final totalLimit = items.fold<int>(0, (s, b) => s + b.limitAmount);
            final totalSpent = items.fold<int>(0, (s, b) => s + b.spent);
            final pct = totalLimit > 0 ? (totalSpent / totalLimit).clamp(0.0, 1.0) : 0.0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total terpakai',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.65),
                            ),
                          ),
                          Row(
                            children: [
                              MoneyText(
                                totalSpent,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              Text(
                                ' / ',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                              MoneyText(
                                totalLimit,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: pct,
                          minHeight: 8,
                          backgroundColor:
                              Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.08),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                ...items.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _BudgetTile(
                        budget: b,
                        onDelete: () => _confirmDelete(context, ref, b.id),
                      ),
                    )),
              ],
            );
          },
          loading: () => const FinkuListSkeleton(count: 4),
          error: (e, _) => FinkuEmptyState(
            icon: Icons.error_outline_rounded,
            title: 'Gagal memuat budget',
            message: e is ApiError ? e.message : e.toString(),
          ),
        ),
      ],
    );
  }

  String _monthLabel(DateTime m) {
    const names = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return names[m.month - 1];
  }

  Future<void> _openAdd(
    BuildContext context,
    WidgetRef ref,
    DateTime month,
    List<CategoryDto> categories,
  ) async {
    if (categories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak ada kategori pengeluaran.')),
      );
      return;
    }
    String catId = categories.first.id;
    final limitCtrl = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Budget baru'),
          content: StatefulBuilder(
            builder: (ctx, setLocal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: catId, // ignore: deprecated_member_use
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text('${c.icon ?? ''} ${c.name}'.trim()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setLocal(() => catId = v ?? catId),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: limitCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Limit (IDR)',
                      hintText: '500000',
                    ),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );

    if (ok != true) return;
    if (!context.mounted) return;
    final lim = int.tryParse(limitCtrl.text.replaceAll(RegExp(r'[^\d]'), ''));
    if (lim == null || lim <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Isi limit valid.')),
      );
      return;
    }
    try {
      await ref.read(budgetsApiProvider).create(
            categoryId: catId,
            periodAnchor: _anchorFirstDay(month),
            limitAmount: lim,
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget ditambahkan.')));
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
        title: const Text('Hapus budget?'),
        content: const Text('Pagu untuk kategori ini akan dihapus.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(budgetsApiProvider).delete(id);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Budget dihapus.')));
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

class _BudgetTile extends StatelessWidget {
  const _BudgetTile({required this.budget, required this.onDelete});

  final BudgetDto budget;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final frac = budget.limitAmount > 0
        ? (budget.spent / budget.limitAmount).clamp(0.0, 1.0)
        : 0.0;
    final name = budget.categoryName ?? 'Kategori';
    return GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  budget.paused ? '$name · dijeda' : name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: frac,
                    minHeight: 6,
                    backgroundColor: scheme.onSurface.withValues(alpha: 0.08),
                    color: frac > 0.9 ? FinkuColors.danger : scheme.primary,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    MoneyText(
                      budget.spent,
                      style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.75)),
                    ),
                    Text(' / ', style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.45))),
                    MoneyText(
                      budget.limitAmount,
                      style: TextStyle(fontSize: 12, color: scheme.onSurface.withValues(alpha: 0.75)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Hapus',
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline_rounded, color: scheme.error.withValues(alpha: 0.85)),
          ),
        ],
      ),
    );
  }
}
