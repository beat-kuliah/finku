import 'package:finku_mobile/src/features/auth/data/dto/auth_dto.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.accessToken,
  });

  final AuthStatus status;
  final AuthUserDto? user;
  final String? accessToken;

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null && accessToken != null;

  /// True when the authenticated user has no username set yet.
  ///
  /// Phase 2 router gate will block app navigation and present
  /// `SetUsernameModal` whenever this is `true`. Returns `false` for
  /// unauthenticated / loading states so callers don't need null checks.
  bool get usernameRequired {
    if (!isAuthenticated) return false;
    final username = user?.username;
    return username == null || username.trim().isEmpty;
  }

  factory AuthState.loading() => const AuthState(status: AuthStatus.loading);
  factory AuthState.unauthenticated() => const AuthState(status: AuthStatus.unauthenticated);
  factory AuthState.authenticated(AuthUserDto user, String accessToken) {
    return AuthState(status: AuthStatus.authenticated, user: user, accessToken: accessToken);
  }
}
