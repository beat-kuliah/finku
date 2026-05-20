import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/transactions/presentation/providers/transactions_providers.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

class TransactionsFilterSheet extends ConsumerStatefulWidget {
  const TransactionsFilterSheet({super.key});

  @override
  ConsumerState<TransactionsFilterSheet> createState() => _TransactionsFilterSheetState();
}

class _TransactionsFilterSheetState extends ConsumerState<TransactionsFilterSheet> {
  DateTime? _from;
  DateTime? _to;
  String? _walletId;
  String? _categoryId;

  List<WalletDto> _wallets = [];
  List<CategoryDto> _categories = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final fromStr = ref.read(transactionDateFromProvider);
    final toStr = ref.read(transactionDateToProvider);
    _walletId = ref.read(transactionWalletFilterProvider);
    _categoryId = ref.read(transactionCategoryFilterProvider);
    if (fromStr != null) {
      try {
        _from = DateTime.parse(fromStr);
      } catch (_) {}
    }
    if (toStr != null) {
      try {
        _to = DateTime.parse(toStr);
      } catch (_) {}
    }
    _load();
  }

  Future<void> _load() async {
    try {
      final results = await Future.wait([
        ref.read(walletsApiProvider).list(),
        ref.read(categoriesApiProvider).list(archived: false),
      ]);
      if (!mounted) return;
      setState(() {
        _wallets = results[0] as List<WalletDto>;
        _categories = results[1] as List<CategoryDto>;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String? _iso(DateTime? d) {
    if (d == null) return null;
    return '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _apply() {
    ref.read(transactionDateFromProvider.notifier).state = _iso(_from);
    ref.read(transactionDateToProvider.notifier).state = _iso(_to);
    ref.read(transactionWalletFilterProvider.notifier).state = _walletId;
    ref.read(transactionCategoryFilterProvider.notifier).state = _categoryId;
    Navigator.of(context).pop();
  }

  void _clear() {
    clearTransactionFilters(ref);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String tx(String key) => l10n.t('transactions', key);

    return FinkuPrimarySheet(
      title: tx('filter.title'),
      footer: Row(
        children: [
          Expanded(
            child: OutlinedButton(onPressed: _clear, child: Text(tx('filter.clear'))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GradientButton(onPressed: _apply, child: Text(tx('apply'))),
          ),
        ],
      ),
      child: _loading
          ? Center(child: Text(tx('loading')))
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tx('filter.dateRange'), style: Theme.of(context).textTheme.labelMedium),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _from ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _from = picked);
                        },
                        child: Text(_from != null ? _iso(_from)! : tx('filter.from')),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _to ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _to = picked);
                        },
                        child: Text(_to != null ? _iso(_to)! : tx('filter.to')),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String?>(
                  value: _walletId, // ignore: deprecated_member_use
                  decoration: InputDecoration(labelText: tx('modal.wallet')),
                  items: [
                    DropdownMenuItem(value: null, child: Text(tx('filter.anyWallet'))),
                    ..._wallets.map(
                      (w) => DropdownMenuItem(value: w.id, child: Text(w.name)),
                    ),
                  ],
                  onChanged: (v) => setState(() => _walletId = v),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _categoryId, // ignore: deprecated_member_use
                  decoration: InputDecoration(labelText: tx('modal.category')),
                  items: [
                    DropdownMenuItem(value: null, child: Text(tx('filter.anyCategory'))),
                    ..._categories.map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text('${c.icon ?? ''} ${c.name}'.trim()),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
              ],
            ),
    );
  }
}

void showTransactionsFilterSheet(BuildContext context) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    builder: (_) => const TransactionsFilterSheet(),
  );
}
