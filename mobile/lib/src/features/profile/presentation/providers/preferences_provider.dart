import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/profile/data/dto/preferences_dto.dart';

final preferencesProvider = FutureProvider.autoDispose<PreferencesDto>((ref) async {
  ref.watch(dataRevisionProvider);
  return ref.watch(preferencesApiProvider).get();
});
