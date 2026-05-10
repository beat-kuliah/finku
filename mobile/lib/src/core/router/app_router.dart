import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/home_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/login_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/register_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/splash_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    ],
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      if (auth.isLoading) {
        return state.matchedLocation == '/splash' ? null : '/splash';
      }
      if (auth.hasError) {
        return '/login';
      }
      final authState = auth.valueOrNull ?? AuthState.unauthenticated();
      if (!authState.isAuthenticated) {
        if (state.matchedLocation == '/login' || state.matchedLocation == '/register') {
          return null;
        }
        return '/login';
      }
      if (state.matchedLocation == '/login' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/splash') {
        return '/home';
      }
      return null;
    },
    refreshListenable: _RiverpodRouterRefresh(ref),
  );
});

class _RiverpodRouterRefresh extends ChangeNotifier {
  _RiverpodRouterRefresh(this._ref) {
    _sub = _ref.listen<AsyncValue<AuthState>>(authControllerProvider, (previous, next) => notifyListeners());
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<AuthState>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
