import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finku_mobile/src/core/providers/api_providers.dart';
import 'package:finku_mobile/src/core/providers/data_revision_provider.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallet_groups_dto.dart';
import 'package:finku_mobile/src/features/wallets/data/dto/wallets_dto.dart';

typedef WalletsSnapshot = ({List<WalletDto> wallets, List<WalletGroupDto> groups});

final walletsTabProvider = StateProvider<bool>((ref) => false);

final walletsDataProvider = FutureProvider.autoDispose<WalletsSnapshot>((ref) async {
  ref.watch(dataRevisionProvider);
  final archived = ref.watch(walletsTabProvider);
  final wallets = await ref.watch(walletsApiProvider).list(archived: archived);
  final groups = archived ? <WalletGroupDto>[] : await ref.watch(walletGroupsApiProvider).list();
  return (wallets: wallets, groups: groups);
});
