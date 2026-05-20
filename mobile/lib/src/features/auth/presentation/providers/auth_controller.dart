import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finku_mobile/src/core/config/env.dart';
import 'package:finku_mobile/src/core/l10n/l10n_bundle.dart';
import 'package:finku_mobile/src/core/network/dio_api_mapper.dart';
import 'package:finku_mobile/src/core/network/dio_client.dart';
import 'package:finku_mobile/src/core/secure_storage/token_store_provider.dart';
import 'package:finku_mobile/src/features/auth/data/auth_api.dart';
import 'package:finku_mobile/src/features/auth/data/auth_repository.dart';
import 'package:finku_mobile/src/features/auth/data/dto/auth_dto.dart';
import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum AuthErrorScope { login, register, google }

/// Maps API/network errors to localized auth strings when a key exists.
String localizedAuthError(WidgetRef ref, Object error, AuthErrorScope scope) {
  final l10n = ref.read(l10nBundleProvider).requireValue;
  final api = mapDioToApiError(error);

  if (api.statusCode == 429) {
    return l10n.t(
      'auth',
      scope == AuthErrorScope.register
          ? 'register.tooManyAttempts'
          : 'login.tooManyAttempts',
    );
  }
  if (api.statusCode == 423) {
    return l10n.t('auth', 'login.accountLocked');
  }

  final isConnectionIssue = error is DioException &&
      (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.sendTimeout ||
          error.type == DioExceptionType.receiveTimeout);
  if (isConnectionIssue || api.statusCode == 0) {
    return l10n.t(
      'auth',
      scope == AuthErrorScope.register
          ? 'register.serverError'
          : 'login.serverError',
    );
  }

  if (scope == AuthErrorScope.google) {
    if (api.message.isNotEmpty) return api.message;
    return l10n.t('auth', 'login.googleFailed');
  }

  if (api.message.isNotEmpty) return api.message;
  return l10n.t(
    'auth',
    scope == AuthErrorScope.register ? 'register.failed' : 'login.failed',
  );
}

final googleSignInProvider = Provider<GoogleSignIn>((ref) {
  final clientId = Env.googleServerClientId;
  return GoogleSignIn.instance..initialize(serverClientId: clientId.isEmpty ? null : clientId);
});

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final l10n = ref.watch(l10nBundleProvider).requireValue;
  return AuthRepository(
    api: ref.read(authApiProvider),
    tokenStore: ref.read(tokenStoreProvider),
    googleSignIn: ref.read(googleSignInProvider),
    authString: (key) => l10n.t('auth', key),
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

  void updateUser(AuthUserDto user) {
    final token = state.valueOrNull?.accessToken;
    if (token == null) return;
    state = AsyncData(AuthState.authenticated(user, token));
  }

  Future<AuthUserDto> setUsername(String username) async {
    final user = await ref.read(authApiProvider).setUsername(username: username);
    updateUser(user);
    return user;
  }

  Future<AuthUserDto> changePassword({
    required String newPassword,
    required String confirmNewPassword,
    String? currentPassword,
  }) async {
    final api = ref.read(authApiProvider);
    final user = currentPassword != null && currentPassword.isNotEmpty
        ? await api.changePassword(
            currentPassword: currentPassword,
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword,
          )
        : await api.setInitialPassword(
            newPassword: newPassword,
            confirmNewPassword: confirmNewPassword,
          );
    updateUser(user);
    return user;
  }

  Future<AuthUserDto> updateProfile({
    String? currency,
    int? monthlyIncome,
    int? payday,
  }) async {
    final user = await ref.read(authApiProvider).updateProfile(
          currency: currency,
          monthlyIncome: monthlyIncome,
          payday: payday,
        );
    updateUser(user);
    return user;
  }

  Future<AuthUserDto> unlinkProvider(String provider) async {
    final user = await ref.read(authApiProvider).unlinkProvider(provider);
    updateUser(user);
    return user;
  }

  Future<String> suggestUsername() => ref.read(authApiProvider).suggestUsername();
}
