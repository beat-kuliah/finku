import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bumped after mutating writes so listeners refresh (mirrors web
/// `useDataVersion`).
///
/// **Refresh convention (Phase 0):** All mutating API calls — across every
/// feature track — must call
/// `ref.read(dataRevisionProvider.notifier).state++` after a successful
/// response so that list providers watching this counter refetch. Read-only
/// queries should `ref.watch(dataRevisionProvider)` if they need to react to
/// remote changes triggered elsewhere.
final dataRevisionProvider = StateProvider<int>((ref) => 0);
