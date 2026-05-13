import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/config/env.dart';
import 'package:finku_mobile/src/core/network/dio_client.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store_provider.dart';
import 'package:finku_mobile/src/features/auth/data/auth_api.dart';
import 'package:finku_mobile/src/features/auth/data/auth_repository.dart';
import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  final clientId = Env.googleServerClientId;
  return GoogleSignIn.instance..initialize(serverClientId: clientId.isEmpty ? null : clientId);
});

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    api: ref.read(authApiProvider),
    tokenStore: ref.read(tokenStoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
  );
});

final authControllerProvider = AsyncNotifierProvider<AuthController, AuthState>(AuthController.new);

class AuthController extends AsyncNotifier<AuthState> {
  AuthRepository get _repo => ref.read(authRepositoryProvider);

  @override
  Future<AuthState> build() async {
    final next = await _repo.bootstrap();
    ref.read(accessTokenProvider.notifier).state = next.accessToken;
    return next;
  }

  Future<void> login({
    required String identifier,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final next = await _repo.login(identifier: identifier, password: password);
      ref.read(accessTokenProvider.notifier).state = next.accessToken;
      return next;
    });
  }

  Future<void> register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final next = await _repo.register(name: name, username: username, email: email, password: password);
      ref.read(accessTokenProvider.notifier).state = next.accessToken;
      return next;
    });
  }

  Future<void> loginWithGoogle() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final next = await _repo.loginWithGoogle();
      ref.read(accessTokenProvider.notifier).state = next.accessToken;
      return next;
    });
  }

  Future<String?> refreshAccessToken() async {
    final token = await _repo.refreshAccessToken();
    if (token == null) {
      ref.read(accessTokenProvider.notifier).state = null;
      state = AsyncData(AuthState.unauthenticated());
      return null;
    }
    ref.read(accessTokenProvider.notifier).state = token;
    final current = state.valueOrNull;
    if (current != null && current.user != null) {
      state = AsyncData(AuthState.authenticated(current.user!, token));
    }
    return token;
  }

  Future<void> logout() async {
    final access = state.valueOrNull?.accessToken;
    await _repo.logout(access);
    ref.read(accessTokenProvider.notifier).state = null;
    state = AsyncData(AuthState.unauthenticated());
  }

  Future<void> forceUnauthenticated() async {
    await _repo.wipeLocalSession();
    ref.read(accessTokenProvider.notifier).state = null;
    state = AsyncData(AuthState.unauthenticated());
  }
}
