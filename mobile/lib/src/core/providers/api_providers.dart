import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/network/dio_client.dart';
import 'package:finku_mobile/src/features/budget/data/budgets_api.dart';
import 'package:finku_mobile/src/features/categories/data/categories_api.dart';
import 'package:finku_mobile/src/features/goals/data/goals_api.dart';
import 'package:finku_mobile/src/features/profile/data/account_api.dart';
import 'package:finku_mobile/src/features/profile/data/preferences_api.dart';
import 'package:finku_mobile/src/features/summary/data/summary_api.dart';
import 'package:finku_mobile/src/features/transactions/data/transactions_api.dart';
import 'package:finku_mobile/src/features/wallets/data/wallet_groups_api.dart';
import 'package:finku_mobile/src/features/wallets/data/wallets_api.dart';

final transactionsApiProvider = Provider<TransactionsApi>((ref) {
  return TransactionsApi(ref.watch(dioProvider));
});

final walletsApiProvider = Provider<WalletsApi>((ref) {
  return WalletsApi(ref.watch(dioProvider));
});

final walletGroupsApiProvider = Provider<WalletGroupsApi>((ref) {
  return WalletGroupsApi(ref.watch(dioProvider));
});

final categoriesApiProvider = Provider<CategoriesApi>((ref) {
  return CategoriesApi(ref.watch(dioProvider));
});

final summaryApiProvider = Provider<SummaryApi>((ref) {
  return SummaryApi(ref.watch(dioProvider));
});

final budgetsApiProvider = Provider<BudgetsApi>((ref) {
  return BudgetsApi(ref.watch(dioProvider));
});

final goalsApiProvider = Provider<GoalsApi>((ref) {
  return GoalsApi(ref.watch(dioProvider));
});

final preferencesApiProvider = Provider<PreferencesApi>((ref) {
  return PreferencesApi(ref.watch(dioProvider));
});

final accountApiProvider = Provider<AccountApi>((ref) {
  return AccountApi(ref.watch(dioProvider));
});
