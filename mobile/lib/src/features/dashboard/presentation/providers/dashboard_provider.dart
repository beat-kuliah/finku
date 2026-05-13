import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/summary/data/dto/summary_dto.dart';

String _isoDate(DateTime d) {
  final y = d.year.toString().padLeft(4, '0');
  final m = d.month.toString().padLeft(2, '0');
  final day = d.day.toString().padLeft(2, '0');
  return '$y-$m-$day';
}

final dashboardDataProvider = FutureProvider.autoDispose<DashboardPayloadDto>((ref) async {
  ref.watch(dataRevisionProvider);
  final now = DateTime.now();
  final from = DateTime(now.year, now.month, 1);
  final to = DateTime(now.year, now.month + 1, 0);
  return ref.watch(summaryApiProvider).fetchDashboard(from: _isoDate(from), to: _isoDate(to));
});
