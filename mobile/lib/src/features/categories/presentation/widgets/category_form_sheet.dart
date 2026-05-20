import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_primary_sheet.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/gradient_button.dart';

const _emojiChoices = ['🍔', '🚗', '🏠', '💊', '🎮', '📚', '✈️', '👕', '💡', '🎁', '🐾', '💼'];

class CategoryFormSheet extends ConsumerStatefulWidget {
  const CategoryFormSheet({
    super.key,
    this.category,
    this.defaultKind = 'expense',
  });

  final CategoryDto? category;
  final String defaultKind;

  @override
  ConsumerState<CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends ConsumerState<CategoryFormSheet> {
  late final TextEditingController _nameCtrl;
  late String _icon;
  late String _kind;
  bool _saving = false;

  bool get _isEdit => widget.category != null;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.category?.name ?? '');
    _icon = widget.category?.icon ?? '🍔';
    _kind = widget.category?.kind ?? widget.defaultKind;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = ref.l10n;
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);
    try {
      final api = ref.read(categoriesApiProvider);
      if (_isEdit) {
        await api.update(widget.category!.id, name: name, icon: _icon);
      } else {
        await api.create(name: name, kind: _kind, icon: _icon);
      }
      ref.read(dataRevisionProvider.notifier).state++;
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              l10n.t('profile', _isEdit ? 'categoryUpdated' : 'categoryAdded'),
            ),
          ),
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
    String p(String k) => l10n.t('profile', k);

    return FinkuPrimarySheet(
      title: p(_isEdit ? 'editCategory' : 'addCategoryTitle'),
      footer: GradientButton(
        onPressed: _saving ? null : _submit,
        child: Text(_saving ? p('saving') : p('save')),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _nameCtrl,
            decoration: InputDecoration(labelText: p('categoryName')),
          ),
          if (!_isEdit) ...[
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _kind, // ignore: deprecated_member_use
              decoration: InputDecoration(labelText: p('categories')),
              items: [
                DropdownMenuItem(value: 'expense', child: Text(p('kindExpense'))),
                DropdownMenuItem(value: 'income', child: Text(p('kindIncome'))),
              ],
              onChanged: (v) => setState(() => _kind = v ?? 'expense'),
            ),
          ],
          const SizedBox(height: 16),
          Text(p('pickEmoji'), style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _emojiChoices.map((e) {
              final selected = _icon == e;
              return ChoiceChip(
                label: Text(e, style: const TextStyle(fontSize: 20)),
                selected: selected,
                onSelected: (_) => setState(() => _icon = e),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

void showCategoryFormSheet(
  BuildContext context, {
  CategoryDto? category,
  String defaultKind = 'expense',
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => CategoryFormSheet(category: category, defaultKind: defaultKind),
  );
}
