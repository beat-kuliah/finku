import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/goals/data/dto/goals_dto.dart';

final goalsListProvider = FutureProvider.autoDispose<List<GoalDto>>((ref) async {
  ref.watch(dataRevisionProvider);
  return ref.watch(goalsApiProvider).list();
});
