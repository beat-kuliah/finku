import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/format_idr.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

class AdjustBalanceSheet extends ConsumerStatefulWidget {
  const AdjustBalanceSheet({super.key, required this.wallet});

  final WalletDto wallet;

  @override
  ConsumerState<AdjustBalanceSheet> createState() => _AdjustBalanceSheetState();
}

class _AdjustBalanceSheetState extends ConsumerState<AdjustBalanceSheet> {
  int _step = 1;
  final _balanceCtrl = TextEditingController();
  DateTime _date = DateTime.now();
  String _recordAs = 'modified';
  String _categoryId = '';
  List<CategoryDto> _catsIncome = [];
  List<CategoryDto> _catsExpense = [];
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _balanceCtrl.text = widget.wallet.balance.toString();
    _load();
  }

  @override
  void dispose() {
    _balanceCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    try {
      final cats = await ref.read(categoriesApiProvider).list(archived: false);
      if (!mounted) return;
      setState(() {
        _catsIncome = cats.where((c) => c.kind == 'income').toList();
        _catsExpense = cats.where((c) => c.kind == 'expense').toList();
        _categoryId = _defaultCat(_catsExpense);
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _defaultCat(List<CategoryDto> list) {
    for (final c in list) {
      if (c.name.toLowerCase().contains('lainnya')) return c.id;
    }
    return list.isNotEmpty ? list.first.id : '';
  }

  int? _parseBalance() {
    final raw = _balanceCtrl.text.trim().replaceAll('.', '');
    return int.tryParse(raw);
  }

  String _iso(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  List<CategoryDto> get _activeCats =>
      _recordAs == 'income' ? _catsIncome : _catsExpense;

  Future<void> _submit() async {
    final l10n = ref.l10n;
    String w(String k) => l10n.t('wallets', k);
    final bal = _parseBalance();
    if (bal == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(w('modal.invalidBalance'))),
      );
      return;
    }
    if (_recordAs != 'modified' && _categoryId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(w('modal.selectCategory'))),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(walletsApiProvider).adjustBalance(
            widget.wallet.id,
            newBalance: bal,
            recordAs: _recordAs,
            categoryId: _recordAs == 'modified' ? null : _categoryId,
            occurredAt: _iso(_date),
          );
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(w('modal.adjusted'))),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String w(String k) => l10n.t('wallets', k);
    final scheme = Theme.of(context).colorScheme;

    return FinkuPrimarySheet(
      title: w('modal.adjustTitle'),
      footer: _step == 1
          ? GradientButton(
              onPressed: _loading
                  ? null
                  : () {
                      if (_parseBalance() == widget.wallet.balance) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(w('modal.noChange'))),
                        );
                        return;
                      }
                      setState(() => _step = 2);
                    },
              child: Text(w('modal.next')),
            )
          : Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => setState(() => _step = 1),
                    child: Text(w('modal.back')),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GradientButton(
                    onPressed: _saving ? null : _submit,
                    child: Text(_saving ? w('saving') : w('modal.confirm')),
                  ),
                ),
              ],
            ),
      child: _loading
          ? Center(child: Text(w('loading')))
          : _step == 1
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '${w('modal.currentBalance')}: ${formatIdr(widget.wallet.balance)}',
                      style: TextStyle(color: scheme.onSurface.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _balanceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(labelText: w('modal.newBalance')),
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _date = picked);
                      },
                      child: Text('${w('modal.date')}: ${_iso(_date)}'),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(w('modal.recordAs'), style: Theme.of(context).textTheme.labelMedium),
                    RadioListTile<String>(
                      title: Text(w('modal.recordAsIncome')),
                      value: 'income',
                      groupValue: _recordAs,
                      onChanged: (v) => setState(() {
                        _recordAs = v!;
                        _categoryId = _defaultCat(_catsIncome);
                      }),
                    ),
                    RadioListTile<String>(
                      title: Text(w('modal.recordAsExpense')),
                      value: 'expense',
                      groupValue: _recordAs,
                      onChanged: (v) => setState(() {
                        _recordAs = v!;
                        _categoryId = _defaultCat(_catsExpense);
                      }),
                    ),
                    RadioListTile<String>(
                      title: Text(w('modal.recordAsModified')),
                      value: 'modified',
                      groupValue: _recordAs,
                      onChanged: (v) => setState(() => _recordAs = v!),
                    ),
                    if (_recordAs != 'modified') ...[
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _categoryId.isEmpty ? null : _categoryId, // ignore: deprecated_member_use
                        decoration: InputDecoration(labelText: w('modal.category')),
                        items: _activeCats
                            .map((c) => DropdownMenuItem(
                                  value: c.id,
                                  child: Text('${c.icon ?? ''} ${c.name}'.trim()),
                                ))
                            .toList(),
                        onChanged: (v) => setState(() => _categoryId = v ?? ''),
                      ),
                    ],
                  ],
                ),
    );
  }
}

void showAdjustBalanceSheet(BuildContext context, WalletDto wallet) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => AdjustBalanceSheet(wallet: wallet),
  );
}
