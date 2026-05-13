import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/budget/data/dto/budgets_dto.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';

String _isoDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

final budgetMonthProvider = StateProvider<DateTime>((ref) => DateTime.now());

final budgetsListProvider = FutureProvider.autoDispose<List<BudgetDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  final anchor = ref.watch(budgetMonthProvider);
  final from = DateTime(anchor.year, anchor.month, 1);
  final to = DateTime(anchor.year, anchor.month + 1, 0);
  return ref.watch(budgetsApiProvider).list(from: _isoDate(from), to: _isoDate(to));
});

final expenseCategoriesProvider = FutureProvider.autoDispose<List<CategoryDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  final cats = await ref.watch(categoriesApiProvider).list(archived: false);
  return cats.where((c) => c.kind == 'expense').toList();
});
