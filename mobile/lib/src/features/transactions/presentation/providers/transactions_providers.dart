import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/transactions/data/dto/transactions_dto.dart';
import 'package:finku_mobile/src/features/transactions/data/transactions_api.dart';

final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

/// `null` = semua jenis; otherwise matches API `kind`.
final transactionKindFilterProvider = StateProvider<String?>((ref) => null);

final transactionDateFromProvider = StateProvider<String?>((ref) => null);
final transactionDateToProvider = StateProvider<String?>((ref) => null);
final transactionWalletFilterProvider = StateProvider<String?>((ref) => null);
final transactionCategoryFilterProvider = StateProvider<String?>((ref) => null);

final transactionsListProvider = FutureProvider.autoDispose<List<TransactionDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  final api = ref.watch(transactionsApiProvider);
  final q = ref.watch(transactionSearchQueryProvider).trim();
  final kind = ref.watch(transactionKindFilterProvider);
  return api.list(
    ListTransactionsQuery(
      q: q.isEmpty ? null : q,
      kind: kind,
      from: ref.watch(transactionDateFromProvider),
      to: ref.watch(transactionDateToProvider),
      walletId: ref.watch(transactionWalletFilterProvider),
      categoryId: ref.watch(transactionCategoryFilterProvider),
    ),
  );
});

final transactionsSummaryProvider = Provider.autoDispose<({int income, int expense})>((ref) {
  final list = ref.watch(transactionsListProvider).valueOrNull ?? const [];
  var income = 0;
  var expense = 0;
  for (final tx in list) {
    if (tx.kind == 'income') {
      income += tx.amount;
    } else if (tx.kind == 'expense') {
      expense += tx.amount;
    }
  }
  return (income: income, expense: expense);
});

void clearTransactionFilters(WidgetRef ref) {
  ref.read(transactionDateFromProvider.notifier).state = null;
  ref.read(transactionDateToProvider.notifier).state = null;
  ref.read(transactionWalletFilterProvider.notifier).state = null;
  ref.read(transactionCategoryFilterProvider.notifier).state = null;
}
