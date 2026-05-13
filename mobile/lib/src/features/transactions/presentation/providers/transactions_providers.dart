import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/transactions/data/dto/transactions_dto.dart';
import 'package:finku_mobile/src/features/transactions/data/transactions_api.dart';

final transactionSearchQueryProvider = StateProvider<String>((ref) => '');

/// `null` = semua jenis; otherwise matches API `kind` (`expense` / `income` / `transfer`).
final transactionKindFilterProvider = StateProvider<String?>((ref) => null);

final transactionsListProvider = FutureProvider.autoDispose<List<TransactionDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  final api = ref.watch(transactionsApiProvider);
  final q = ref.watch(transactionSearchQueryProvider).trim();
  final kind = ref.watch(transactionKindFilterProvider);
  return api.list(
    ListTransactionsQuery(
      q: q.isEmpty ? null : q,
      kind: kind,
    ),
  );
});
