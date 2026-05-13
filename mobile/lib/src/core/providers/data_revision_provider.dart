import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Bumped after mutating writes so listeners refresh (mirrors web `useDataVersion`).
final dataRevisionProvider = StateProvider<int>((ref) => 0);
