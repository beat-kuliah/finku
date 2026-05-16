import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/format_idr.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/core/theme/app_colors.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

enum _TxTab { expense, income, transfer }

class AddTransactionSheet extends ConsumerStatefulWidget {
  const AddTransactionSheet({super.key});

  @override
  ConsumerState<AddTransactionSheet> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends ConsumerState<AddTransactionSheet>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  final _amountCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  bool _loading = true;
  String? _loadError;

  List<WalletDto> _wallets = [];
  Map<String, String> _groupNames = {};
  List<CategoryDto> _catsIncome = [];
  List<CategoryDto> _catsExpense = [];

  String _walletId = '';
  String _destWalletId = '';
  String _categoryId = '';
  DateTime _occurredAt = DateTime.now();

  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _tabs.addListener(() {
      if (_tabs.indexIsChanging) return;
      if (_tabs.index != 2) {
        _syncCategoryForTab();
      } else {
        setState(() {});
      }
    });
    _bootstrap();
  }

  @override
  void dispose() {
    _tabs.dispose();
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
      final walletsApi = ref.read(walletsApiProvider);
      final groupsApi = ref.read(walletGroupsApiProvider);
      final catApi = ref.read(categoriesApiProvider);

      final results = await Future.wait([
        walletsApi.list(),
        groupsApi.list(),
        catApi.list(archived: false),
      ]);

      final wallets = results[0] as List<WalletDto>;
      final groups = results[1] as List<WalletGroupDto>;
      final cats = results[2] as List<CategoryDto>;

      final income = cats.where((c) => c.kind == 'income').toList();
      final expense = cats.where((c) => c.kind == 'expense').toList();
      final gmap = {for (final g in groups) g.id: g.name};

      String walletId = '';
      if (wallets.isNotEmpty) walletId = wallets.first.id;

      String pickDefaultCat(List<CategoryDto> list) {
        for (final c in list) {
          if (c.name.toLowerCase().contains('lainnya')) return c.id;
        }
        return list.isNotEmpty ? list.first.id : '';
      }

      if (!mounted) return;
      setState(() {
        _wallets = wallets;
        _groupNames = gmap;
        _catsIncome = income;
        _catsExpense = expense;
        _walletId = walletId;
        _destWalletId = '';
        _categoryId = _tabs.index == 1 ? pickDefaultCat(income) : pickDefaultCat(expense);
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

  _TxTab get _tab => switch (_tabs.index) {
        1 => _TxTab.income,
        2 => _TxTab.transfer,
        _ => _TxTab.expense,
      };

  List<CategoryDto> get _activeCats => _tab == _TxTab.income ? _catsIncome : _catsExpense;

  String _walletLabel(WalletDto w) {
    final bal = formatIdr(w.balance, withPrefix: false);
    final gid = w.groupId;
    final gname = gid != null && gid.isNotEmpty ? _groupNames[gid] : null;
    if (gname != null && gname.isNotEmpty) {
      return '$gname · ${w.name} ($bal)';
    }
    return '${w.name} ($bal)';
  }

  int? _parseAmount() {
    final raw = _amountCtrl.text.trim();
    if (raw.isEmpty) return null;
    final normalized = raw.replaceAll('.', '').replaceAll(',', '.');
    final v = double.tryParse(normalized);
    if (v == null || v <= 0) return null;
    return v.round();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => _occurredAt = picked);
  }

  String _isoDate(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '$y-$m-$day';
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

    final occurredAt = _isoDate(_occurredAt);
    final desc = _descCtrl.text.trim();

    if (_tab == _TxTab.transfer) {
      if (_destWalletId.isEmpty || _destWalletId == _walletId) {
        _toast(tx('modal.selectDestWallet'));
        return;
      }
    } else if (_categoryId.isEmpty) {
      _toast(tx('modal.selectCategory'));
      return;
    }

    setState(() => _saving = true);
    try {
      final api = ref.read(transactionsApiProvider);
      if (_tab == _TxTab.transfer) {
        await api.create(
          kind: 'transfer',
          walletId: _walletId,
          destWalletId: _destWalletId,
          amount: amt,
          occurredAt: occurredAt,
          description: desc.isEmpty ? null : desc,
        );
      } else {
        await api.create(
          kind: _tab == _TxTab.income ? 'income' : 'expense',
          walletId: _walletId,
          categoryId: _categoryId,
          amount: amt,
          occurredAt: occurredAt,
          description: desc.isEmpty ? null : desc,
        );
      }
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.of(context).pop();
        messenger.showSnackBar(
          SnackBar(content: Text(tx('modal.saved'))),
        );
      }
    } catch (e) {
      final msg = e is ApiError ? e.message : tx('modal.saveFailed');
      _toast(msg);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  void _syncCategoryForTab() {
    final list = _activeCats;
    String pickDefault() {
      for (final c in list) {
        if (c.name.toLowerCase().contains('lainnya')) return c.id;
      }
      return list.isNotEmpty ? list.first.id : '';
    }

    setState(() {
      _categoryId = pickDefault();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String tx(String key) => l10n.t('transactions', key);
    final scheme = Theme.of(context).colorScheme;
    final mq = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: FinkuPrimarySheet(
        title: tx('modal.title'),
        subtitle: l10n.t('nav', 'addTransaction'),
        maxHeightFraction: 0.92,
        scrollBody: false,
        onClose: () => Navigator.of(context).pop(),
        footer: GradientButton(
          onPressed: _saving || _loading ? null : () => _submit(),
          child: Text(_saving ? tx('saving') : tx('save')),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: TabBar(
                controller: _tabs,
                indicator: BoxDecoration(
                  gradient: FinkuColors.gradientNeon,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: FinkuColors.neonGlow(opacity: 0.25, blur: 14),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: scheme.onSurface.withValues(alpha: 0.65),
                labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                tabs: [
                  Tab(text: tx('expense')),
                  Tab(text: tx('income')),
                  Tab(text: tx('transfer')),
                ],
              ),
            ),
            Expanded(
              child: _loading
                  ? Center(
                      child: Text(
                        tx('loading'),
                        style: TextStyle(
                          color: scheme.onSurface.withValues(alpha: 0.65),
                        ),
                      ),
                    )
                  : _loadError != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              '${tx('modal.loadFailed')}\n$_loadError',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: scheme.error),
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                tx('modal.amount'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _amountCtrl,
                                keyboardType: TextInputType.number,
                                decoration: _inputDecoration(
                                  context,
                                  hintText: tx('modal.amountPlaceholder'),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                tx('modal.date'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: 6),
                              InkWell(
                                onTap: _pickDate,
                                borderRadius: BorderRadius.circular(14),
                                child: InputDecorator(
                                  decoration: _inputDecoration(context),
                                  child: Text(_isoDate(_occurredAt)),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                tx('modal.wallet'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                value: _walletId.isEmpty ? null : _walletId, // ignore: deprecated_member_use
                                decoration: _inputDecoration(context),
                                items: _wallets
                                    .map(
                                      (w) => DropdownMenuItem(
                                        value: w.id,
                                        child: Text(_walletLabel(w), overflow: TextOverflow.ellipsis),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) => setState(() {
                                  _walletId = v ?? '';
                                  if (_destWalletId == _walletId) _destWalletId = '';
                                }),
                              ),
                              if (_tab == _TxTab.transfer) ...[
                                const SizedBox(height: 14),
                                Text(
                                  tx('modal.destWallet'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: scheme.onSurface.withValues(alpha: 0.65),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _destWalletId.isEmpty ? null : _destWalletId, // ignore: deprecated_member_use
                                  decoration: _inputDecoration(context),
                                  items: _wallets
                                      .where((w) => w.id != _walletId)
                                      .map(
                                        (w) => DropdownMenuItem(
                                          value: w.id,
                                          child:
                                              Text(_walletLabel(w), overflow: TextOverflow.ellipsis),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => _destWalletId = v ?? ''),
                                ),
                              ] else ...[
                                const SizedBox(height: 14),
                                Text(
                                  tx('modal.category'),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: scheme.onSurface.withValues(alpha: 0.65),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: _categoryId.isEmpty ? null : _categoryId, // ignore: deprecated_member_use
                                  decoration: _inputDecoration(context),
                                  items: _activeCats
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c.id,
                                          child: Text(
                                            '${c.icon ?? ''} ${c.name}'.trim(),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) => setState(() => _categoryId = v ?? ''),
                                ),
                              ],
                              const SizedBox(height: 14),
                              Text(
                                tx('modal.note'),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface.withValues(alpha: 0.65),
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextField(
                                controller: _descCtrl,
                                decoration: _inputDecoration(context),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, {String? hintText}) {
    final scheme = Theme.of(context).colorScheme;
    final tokens = FinkuColors.glassTokens(Theme.of(context).brightness);
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: tokens.fill,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }
}
