import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/categories/data/dto/categories_dto.dart';

final categoriesActiveProvider = FutureProvider.autoDispose<List<CategoryDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  return ref.watch(categoriesApiProvider).list(archived: false);
});

final categoriesArchivedProvider = FutureProvider.autoDispose<List<CategoryDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  return ref.watch(categoriesApiProvider).list(archived: true);
});
