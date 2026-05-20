import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:finku_mobile/src/features/auth/domain/auth_state.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/landing_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/login_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/register_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/pages/splash_page.dart';
import 'package:finku_mobile/src/features/categories/presentation/categories_page.dart';
import 'package:finku_mobile/src/features/auth/presentation/providers/auth_controller.dart';
import 'package:finku_mobile/src/features/budget/presentation/budget_page.dart';
import 'package:finku_mobile/src/features/dashboard/presentation/dashboard_page.dart';
import 'package:finku_mobile/src/features/goals/presentation/goals_page.dart';
import 'package:finku_mobile/src/features/profile/presentation/profile_page.dart';
import 'package:finku_mobile/src/features/shell/presentation/app_shell.dart';
import 'package:finku_mobile/src/features/stats/presentation/stats_page.dart';
import 'package:finku_mobile/src/features/transactions/presentation/transactions_page.dart';
import 'package:finku_mobile/src/features/wallets/presentation/wallets_page.dart';

/// Routes outside the shell (no bottom dock / header chrome).
const _kAuthRoutes = <String>{'/splash', '/landing', '/login', '/register'};

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: kDebugMode,
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/landing', builder: (context, state) => const LandingPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterPage()),
      GoRoute(path: '/categories', builder: (context, state) => const CategoriesPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/transactions',
                builder: (context, state) => const TransactionsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallets',
                builder: (context, state) => const WalletsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/budget',
                builder: (context, state) => const BudgetPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/stats',
                builder: (context, state) => const StatsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/goals',
                builder: (context, state) => const GoalsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      final auth = ref.read(authControllerProvider);
      final loc = state.matchedLocation;

      if (loc == '/home') {
        return '/dashboard';
      }

      if (auth.isLoading) {
        return loc == '/splash' ? null : '/splash';
      }
      if (auth.hasError) {
        return '/login';
      }

      final authState = auth.valueOrNull ?? AuthState.unauthenticated();
      if (!authState.isAuthenticated) {
        if (loc == '/landing' || loc == '/login' || loc == '/register') {
          return null;
        }
        return '/landing';
      }

      if (_kAuthRoutes.contains(loc)) {
        return '/dashboard';
      }
      return null;
    },
    refreshListenable: _RiverpodRouterRefresh(ref),
  );
});

class _RiverpodRouterRefresh extends ChangeNotifier {
  _RiverpodRouterRefresh(this._ref) {
    _sub = _ref.listen<AsyncValue<AuthState>>(
      authControllerProvider,
      (previous, next) => notifyListeners(),
    );
  }

  final Ref _ref;
  late final ProviderSubscription<AsyncValue<AuthState>> _sub;

  @override
  void dispose() {
    _sub.close();
    super.dispose();
  }
}
