import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStore {
  TokenStore(this._storage);

  static const _refreshTokenKey = 'auth.refreshToken';
  final FlutterSecureStorage _storage;

  Future<void> saveRefreshToken(String token) {
    return _storage.write(
      key: _refreshTokenKey,
      value: token,
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    );
  }

  Future<String?> readRefreshToken() {
    return _storage.read(
      key: _refreshTokenKey,
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    );
  }

  Future<void> clear() {
    return _storage.delete(
      key: _refreshTokenKey,
      iOptions: const IOSOptions(accessibility: KeychainAccessibility.first_unlock_this_device),
    );
  }
}
