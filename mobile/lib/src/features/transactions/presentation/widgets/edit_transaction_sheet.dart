import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/format_idr.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/transactions/data/dto/transactions_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

enum _EditKind { modified, expense, income, transfer }

class EditTransactionSheet extends ConsumerStatefulWidget {
  const EditTransactionSheet({super.key, required this.transaction});

  final TransactionDto transaction;

  @override
  ConsumerState<EditTransactionSheet> createState() => _EditTransactionSheetState();
}

class _EditTransactionSheetState extends ConsumerState<EditTransactionSheet> {
  late _EditKind _kind;
  late bool _balanceIncrease;

  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool _loading = true;
  String? _loadError;
  bool _saving = false;

  List<WalletDto> _wallets = [];
  Map<String, String> _groupNames = {};
  List<CategoryDto> _catsIncome = [];
  List<CategoryDto> _catsExpense = [];

  String _walletId = '';
  String _destWalletId = '';
  String _categoryId = '';
  DateTime _occurredAt = DateTime.now();

  bool get _fromModified => widget.transaction.kind == 'modified';

  @override
  void initState() {
    super.initState();
    final tx = widget.transaction;
    _fromModified
        ? _kind = _EditKind.modified
        : _kind = switch (tx.kind) {
            'transfer' => _EditKind.transfer,
            'income' => _EditKind.income,
            _ => _EditKind.expense,
          };
    _balanceIncrease = tx.isBalanceIncrease ?? true;
    _amountCtrl.text = tx.amount.toString();
    _descCtrl.text = tx.description ?? '';
    _walletId = tx.walletId;
    _destWalletId = tx.destWalletId ?? '';
    _categoryId = tx.categoryId ?? '';
    try {
      _occurredAt = DateTime.parse(tx.occurredAt).toLocal();
    } catch (_) {
      _occurredAt = DateTime.now();
    }
    _bootstrap();
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final results = await Future.wait([
        ref.read(walletsApiProvider).list(),
        ref.read(walletGroupsApiProvider).list(),
        ref.read(categoriesApiProvider).list(archived: false),
      ]);
      final wallets = results[0] as List<WalletDto>;
      final groups = results[1] as List<WalletGroupDto>;
      final cats = results[2] as List<CategoryDto>;
      if (!mounted) return;
      setState(() {
        _wallets = wallets;
        _groupNames = {for (final g in groups) g.id: g.name};
        _catsIncome = cats.where((c) => c.kind == 'income').toList();
        _catsExpense = cats.where((c) => c.kind == 'expense').toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _loadError = mapDioToApiError(e).message;
      });
    }
  }

  List<_EditKind> get _tabs =>
      _fromModified ? [_EditKind.modified, _EditKind.expense, _EditKind.income] : [_EditKind.expense, _EditKind.income, _EditKind.transfer];

  List<CategoryDto> get _activeCats =>
      _kind == _EditKind.income ? _catsIncome : _catsExpense;

  String _walletLabel(WalletDto w) {
    final bal = formatIdr(w.balance, withPrefix: false);
    final gname = w.groupId != null ? _groupNames[w.groupId] : null;
    if (gname != null && gname.isNotEmpty) return '$gname · ${w.name} ($bal)';
    return '${w.name} ($bal)';
  }

  int? _parseAmount() {
    final raw = _amountCtrl.text.trim().replaceAll('.', '');
    final v = int.tryParse(raw);
    return v != null && v > 0 ? v : null;
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _apiKind() {
    if (_fromModified && _kind == _EditKind.modified) return 'modified';
    return switch (_kind) {
      _EditKind.income => 'income',
      _EditKind.transfer => 'transfer',
      _ => 'expense',
    };
  }

  Future<void> _submit() async {
    String tx(String key) => ref.l10n.t('transactions', key);
    final amt = _parseAmount();
    if (amt == null) {
      _toast(tx('modal.invalidAmount'));
      return;
    }
    if (_walletId.isEmpty) {
      _toast(tx('modal.selectWallet'));
      return;
    }
    if (_kind == _EditKind.transfer) {
      if (_destWalletId.isEmpty || _destWalletId == _walletId) {
        _toast(tx('modal.selectDestWallet'));
        return;
      }
    } else if (_kind != _EditKind.modified && _categoryId.isEmpty) {
      _toast(tx('modal.selectCategory'));
      return;
    }

    setState(() => _saving = true);
    try {
      await ref.read(transactionsApiProvider).update(
            widget.transaction.id,
            kind: _apiKind(),
            walletId: _walletId,
            destWalletId: _kind == _EditKind.transfer ? _destWalletId : null,
            categoryId: _kind == _EditKind.transfer || _kind == _EditKind.modified && !_fromModified
                ? null
                : (_categoryId.isEmpty ? null : _categoryId),
            amount: amt,
            occurredAt: _isoDate(_occurredAt),
            description: _descCtrl.text.trim().isEmpty ? null : _descCtrl.text.trim(),
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(tx('modal.saved'))),
        );
      }
    } catch (e) {
      _toast(e is ApiError ? e.message : tx('modal.saveFailed'));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String tx(String key) => l10n.t('transactions', key);
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: FinkuPrimarySheet(
        title: tx('edit.title'),
        scrollBody: false,
        onClose: () => Navigator.of(context).pop(),
        footer: GradientButton(
          onPressed: _saving || _loading ? null : _submit,
          child: Text(_saving ? tx('saving') : tx('save')),
        ),
        child: Column(
          children: [
            if (!_fromModified)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Row(
                  children: _tabs.map((k) {
                    final selected = _kind == k;
                    final label = switch (k) {
                      _EditKind.income => tx('income'),
                      _EditKind.transfer => tx('transfer'),
                      _EditKind.modified => tx('modified'),
                      _ => tx('expense'),
                    };
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(label, style: const TextStyle(fontSize: 12)),
                          selected: selected,
                          onSelected: (_) => setState(() => _kind = k),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            Expanded(
              child: _loading
                  ? Center(child: Text(tx('loading')))
                  : _loadError != null
                      ? Center(child: Text(_loadError!, style: TextStyle(color: scheme.error)))
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (_fromModified && _kind == _EditKind.modified) ...[
                                Text(tx('modified.direction'), style: _labelStyle(scheme)),
                                const SizedBox(height: 6),
                                SegmentedButton<bool>(
                                  segments: [
                                    ButtonSegment(value: true, label: Text(tx('modified.up'))),
                                    ButtonSegment(value: false, label: Text(tx('modified.down'))),
                                  ],
                                  selected: {_balanceIncrease},
                                  onSelectionChanged: (s) =>
                                      setState(() => _balanceIncrease = s.first),
                                ),
                                const SizedBox(height: 14),
                              ],
                              Text(tx('modal.amount'), style: _labelStyle(scheme)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _amountCtrl,
                                keyboardType: TextInputType.number,
                              ),
                              const SizedBox(height: 14),
                              Text(tx('modal.date'), style: _labelStyle(scheme)),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _occurredAt,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) setState(() => _occurredAt = picked);
                                },
                                child: InputDecorator(
                                  decoration: const InputDecoration(border: OutlineInputBorder()),
                                  child: Text(_isoDate(_occurredAt)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(tx('modal.wallet'), style: _labelStyle(scheme)),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _walletId.isEmpty ? null : _walletId, // ignore: deprecated_member_use
                                items: _wallets
                                    .map((w) => DropdownMenuItem(
                                          value: w.id,
                                          child: Text(_walletLabel(w), overflow: TextOverflow.ellipsis),
                                        ))
                                    .toList(),
                                onChanged: (v) => setState(() {
                                  _walletId = v ?? '';
                                  if (_destWalletId == _walletId) _destWalletId = '';
                                }),
                              ),
                              if (_kind == _EditKind.transfer) ...[
                                const SizedBox(height: 14),
                                Text(tx('modal.destWallet'), style: _labelStyle(scheme)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _destWalletId.isEmpty ? null : _destWalletId, // ignore: deprecated_member_use
                                  items: _wallets
                                      .where((w) => w.id != _walletId)
                                      .map((w) => DropdownMenuItem(
                                            value: w.id,
                                            child: Text(_walletLabel(w), overflow: TextOverflow.ellipsis),
                                          ))
                                      .toList(),
                                  onChanged: (v) => setState(() => _destWalletId = v ?? ''),
                                ),
                              ] else if (_kind != _EditKind.modified || _fromModified) ...[
                                const SizedBox(height: 14),
                                Text(tx('modal.category'), style: _labelStyle(scheme)),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _categoryId.isEmpty ? null : _categoryId, // ignore: deprecated_member_use
                                  items: _activeCats
                                      .map((c) => DropdownMenuItem(
                                            value: c.id,
                                            child: Text('${c.icon ?? ''} ${c.name}'.trim()),
                                          ))
                                      .toList(),
                                  onChanged: (v) => setState(() => _categoryId = v ?? ''),
                                ),
                              ],
                              const SizedBox(height: 14),
                              Text(tx('modal.note'), style: _labelStyle(scheme)),
                              const SizedBox(height: 6),
                              TextField(controller: _descCtrl),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle _labelStyle(ColorScheme scheme) => TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: scheme.onSurface.withValues(alpha: 0.65),
      );
}

void showEditTransactionSheet(BuildContext context, TransactionDto tx) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: false,
    builder: (_) => EditTransactionSheet(transaction: tx),
  );
}
