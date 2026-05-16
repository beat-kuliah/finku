import 'package:finku_mobile/src/core/errors/api_error.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store.dart';
import 'package:finku_mobile/src/features/auth/data/auth_api.dart';
import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

typedef AuthString = String Function(String key);

class AuthRepository {
  AuthRepository({
    required AuthApi api,
    required TokenStore tokenStore,
    required GoogleSignIn googleSignIn,
    AuthString? authString,
  })  : _api = api,
        _tokenStore = tokenStore,
        _googleSignIn = googleSignIn,
        _authString = authString ?? ((_) => '');

  final AuthApi _api;
  final TokenStore _tokenStore;
  final GoogleSignIn _googleSignIn;
  final AuthString _authString;

  String _t(String key) => _authString(key);

  Future<AuthState> bootstrap() async {
    final refresh = await _tokenStore.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return AuthState.unauthenticated();
    }
    try {
      final refreshed = await _api.refresh(refresh);
      await _tokenStore.saveRefreshToken(refreshed.refreshToken);
      final user = await _api.me(refreshed.accessToken);
      return AuthState.authenticated(user, refreshed.accessToken);
    } catch (_) {
      await _tokenStore.clear();
      return AuthState.unauthenticated();
    }
  }

  Future<AuthState> login({
    required String identifier,
    required String password,
  }) async {
    final res = await _api.login(identifier: identifier, password: password);
    await _tokenStore.saveRefreshToken(res.refreshToken);
    return AuthState.authenticated(res.user, res.accessToken);
  }

  Future<AuthState> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    final res = await _api.register(
      name: name,
      username: username,
      email: email,
      password: password,
    );
    await _tokenStore.saveRefreshToken(res.refreshToken);
    return AuthState.authenticated(res.user, res.accessToken);
  }

  Future<AuthState> loginWithGoogle() async {
    final account = await _googleSignIn.authenticate();
    final auth = account.authentication;
    final idToken = auth.idToken;
    if (idToken == null || idToken.isEmpty) {
      throw ApiError(
        message: _t('oauth.noCredential'),
        statusCode: 0,
      );
    }
    final res = await _api.loginWithGoogle(idToken);
    await _tokenStore.saveRefreshToken(res.refreshToken);
    return AuthState.authenticated(res.user, res.accessToken);
  }

  Future<String?> refreshAccessToken() async {
    final refresh = await _tokenStore.readRefreshToken();
    if (refresh == null || refresh.isEmpty) {
      return null;
    }
    final res = await _api.refresh(refresh);
    await _tokenStore.saveRefreshToken(res.refreshToken);
    return res.accessToken;
  }

  Future<void> logout(String? accessToken) async {
    final refresh = await _tokenStore.readRefreshToken();
    if (refresh != null && refresh.isNotEmpty && accessToken != null && accessToken.isNotEmpty) {
      try {
        await _api.logout(refreshToken: refresh, accessToken: accessToken);
      } catch (_) {
        // Force local logout even if backend request fails.
      }
    }
    await _googleSignIn.signOut();
    await _tokenStore.clear();
  }

  Future<void> wipeLocalSession() => _tokenStore.clear();
}
