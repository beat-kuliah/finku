import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/l10n/l10n_extensions.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/presentation/finku_empty_state.dart';
import 'package:finku_mobile/src/core/presentation/finku_list_skeleton.dart';
import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';
import 'package:finku_mobile/src/features/categories/presentation/providers/categories_provider.dart';
import 'package:finku_mobile/src/features/categories/presentation/widgets/category_form_sheet.dart';
import 'package:finku_mobile/src/features/shell/presentation/widgets/glass_card.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  bool _archived = false;

  @override
  Widget build(BuildContext context) {
    final l10n = ref.l10n;
    String p(String k) => l10n.t('profile', k);
    final async = _archived
        ? ref.watch(categoriesArchivedProvider)
        : ref.watch(categoriesActiveProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(p('categories')),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ChoiceChip(
                    label: Text(p('active')),
                    selected: !_archived,
                    onSelected: (_) => setState(() => _archived = false),
                  ),
                  const SizedBox(width: 8),
                  ChoiceChip(
                    label: Text(p('archived')),
                    selected: _archived,
                    onSelected: (_) => setState(() => _archived = true),
                  ),
                  const Spacer(),
                  if (!_archived)
                    TextButton.icon(
                      onPressed: () => showCategoryFormSheet(context),
                      icon: const Icon(Icons.add_rounded),
                      label: Text(p('addCategory')),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: async.when(
                  data: (list) {
                    if (list.isEmpty) {
                      return FinkuEmptyState(
                        icon: Icons.category_outlined,
                        title: p(_archived ? 'noArchivedCategories' : 'noCategories'),
                        message: p('categories'),
                      );
                    }
                    return ListView.separated(
                      itemCount: list.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 8),
                      itemBuilder: (_, i) => _CategoryTile(
                        category: list[i],
                        archived: _archived,
                      ),
                    );
                  },
                  loading: () => const FinkuListSkeleton(count: 5),
                  error: (e, _) => FinkuEmptyState(
                    icon: Icons.error_outline_rounded,
                    title: p('loadFailed'),
                    message: e.toString(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryTile extends ConsumerWidget {
  const _CategoryTile({required this.category, required this.archived});

  final CategoryDto category;
  final bool archived;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.l10n;
    String p(String k) => l10n.t('profile', k);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Text(category.icon ?? '📁', style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(category.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                Text(
                  category.kind == 'income' ? p('kindIncome') : p('kindExpense'),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
                  ),
                ),
              ],
            ),
          ),
          if (!archived) ...[
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => showCategoryFormSheet(context, category: category),
            ),
            IconButton(
              icon: const Icon(Icons.archive_outlined),
              onPressed: () => _archive(context, ref),
            ),
          ] else
            TextButton(
              onPressed: () => _unarchive(context, ref),
              child: Text(p('restoreCategory')),
            ),
        ],
      ),
    );
  }

  Future<void> _archive(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(categoriesApiProvider).archive(category.id);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.l10n.t('profile', 'categoryArchived'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }

  Future<void> _unarchive(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(categoriesApiProvider).unarchive(category.id);
      ref.read(dataRevisionProvider.notifier).state++;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.l10n.t('profile', 'categoryRestored'))),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(mapDioToApiError(e).message)),
        );
      }
    }
  }
}
