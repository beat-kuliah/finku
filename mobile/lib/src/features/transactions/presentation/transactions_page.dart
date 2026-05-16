import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/app_locale.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/presentation/format_dates.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_filter_chips.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/presentation/money_text.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/placeholder_section.dart';
import 'package:finku_mobile/src/features/transactions/data/dto/transactions_dto.dart';
import 'package:finku_mobile/src/features/transactions/presentation/providers/transactions_providers.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  final _searchCtrl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _scheduleSearch(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 380), () {
      ref.read(transactionSearchQueryProvider.notifier).state = value.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String tx(String key, {Map<String, String>? args}) =>
        l10n.t('transactions', key, args: args);
    final scheme = Theme.of(context).colorScheme;
    final kind = ref.watch(transactionKindFilterProvider);
    final asyncTx = ref.watch(transactionsListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: BranchScaffold(
            wrapInScrollView: false,
            title: tx('sectionLabel'),
            subtitle: tx('subtitle'),
            children: [
              Semantics(
                label: tx('searchPlaceholder'),
                textField: true,
                child: TextField(
                  controller: _searchCtrl,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: tx('searchPlaceholder'),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchCtrl.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: tx('close'),
                            onPressed: () {
                              _searchCtrl.clear();
                              ref.read(transactionSearchQueryProvider.notifier).state = '';
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: FinkuColors.glassTokens(Theme.of(context).brightness).fill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: scheme.outlineVariant),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: scheme.outlineVariant),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {});
                    _scheduleSearch(v);
                  },
                ),
              ),
              const SizedBox(height: 14),
              FinkuFilterChips(
                chips: [
                  FinkuFilterChipData(id: '', label: tx('allKinds')),
                  FinkuFilterChipData(id: 'expense', label: tx('expense')),
                  FinkuFilterChipData(id: 'income', label: tx('income')),
                  FinkuFilterChipData(id: 'transfer', label: tx('transfer')),
                ],
                selectedId: kind ?? '',
                onSelected: (id) =>
                    ref.read(transactionKindFilterProvider.notifier).state = id.isEmpty ? null : id,
              ),
              const SizedBox(height: 18),
              Expanded(
                child: asyncTx.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          FinkuEmptyState(
                            icon: Icons.receipt_long_rounded,
                            title: tx('noTransactions'),
                            message: l10n.t('nav', 'addTransaction'),
                          ),
                        ],
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(transactionsListProvider);
                        await ref.read(transactionsListProvider.future);
                      },
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: list.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, i) => _TransactionTile(tx: list[i]),
                      ),
                    );
                  },
                  loading: () => const SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: FinkuListSkeleton(count: 5),
                  ),
                  error: (e, _) => ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      _TxErrorCard(error: e),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TransactionTile extends StatelessWidget {
  const _TransactionTile({required this.tx});

  final TransactionDto tx;

  String _kindLabel(L10nBundle l10n, String kind) {
    if (kind == 'income' || kind == 'expense' || kind == 'transfer') {
      return l10n.t('transactions', kind);
    }
    return kind;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final scheme = Theme.of(context).colorScheme;
    final kindLabel = _kindLabel(l10n, tx.kind);
    final (icon, color) = switch (tx.kind) {
      'income' => (Icons.south_west_rounded, FinkuColors.success),
      'transfer' => (Icons.swap_horiz_rounded, scheme.primary),
      _ => (Icons.north_east_rounded, FinkuColors.danger),
    };

    final title = tx.description?.trim().isNotEmpty == true
        ? tx.description!.trim()
        : (tx.categoryName?.trim().isNotEmpty == true
            ? tx.categoryName!
            : kindLabel);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Semantics(
            label: kindLabel,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: scheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_formatDate(tx.occurredAt, l10n.locale)} · $kindLabel',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: scheme.onSurface.withValues(alpha: 0.62),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          MoneyText(
            tx.amount,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 14,
              color: tx.kind == 'income'
                  ? FinkuColors.success
                  : (tx.kind == 'transfer' ? scheme.primary : FinkuColors.danger),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(String iso, AppLocale locale) {
    try {
      return formatDate(DateTime.parse(iso).toLocal(), locale, pattern: 'dd/MM/y');
    } catch (_) {
      return iso;
    }
  }
}

class _TxErrorCard extends StatelessWidget {
  const _TxErrorCard({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final msg = error is ApiError ? (error as ApiError).message : error.toString();
    return GlassCard(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error_outline_rounded, color: scheme.error),
              const SizedBox(width: 10),
              Text(
                context.l10n.t('transactions', 'loadFailed'),
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            msg,
            style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.75), height: 1.4),
          ),
        ],
      ),
    );
  }
}
