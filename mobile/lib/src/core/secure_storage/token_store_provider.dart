import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) => const FlutterSecureStorage());

final tokenStoreProvider = Provider<TokenStore>((ref) {
  return TokenStore(ref.read(secureStorageProvider));
});
