import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/history/screens/history_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../features/machines_map/screens/machines_map_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/onboarding/screens/onboarding_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/referral/screens/referral_screen.dart';
import '../../features/scan_deposit/screens/scan_deposit_screen.dart';
import '../../features/shell/app_shell.dart';
import '../../features/splash/splash_screen.dart';
import '../../features/wallet/screens/wallet_screen.dart';
import '../../features/withdraw/screens/withdraw_screen.dart';
import '../providers/app_providers.dart';

/// Named routes + custom transitions for EcoStudent.
final _rootKey = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  final settings = ref.watch(settingsProvider);

  return GoRouter(
    navigatorKey: _rootKey,
    initialLocation: '/',
    refreshListenable: _SettingsListenable(ref),
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final onboardingDone = settings.onboardingDone;
      final user = ref.read(authUserProvider).valueOrNull;
      final loggedIn = user != null;

      if (loc == '/') return null; // splash handles itself

      if (!onboardingDone && loc != '/onboarding') {
        return '/onboarding';
      }
      if (onboardingDone && loc == '/onboarding') {
        return loggedIn ? '/home' : '/login';
      }

      final authRoutes = {'/login', '/signup', '/forgot-password'};
      if (!loggedIn &&
          onboardingDone &&
          !authRoutes.contains(loc) &&
          loc != '/onboarding') {
        return '/login';
      }
      if (loggedIn && authRoutes.contains(loc)) {
        return '/home';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _fade(const SplashScreen(), state),
      ),
      GoRoute(
        path: '/onboarding',
        pageBuilder: (context, state) =>
            _fade(const OnboardingScreen(), state),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => _fade(const LoginScreen(), state),
      ),
      GoRoute(
        path: '/signup',
        pageBuilder: (context, state) =>
            _slideUp(const SignUpScreen(), state),
      ),
      GoRoute(
        path: '/forgot-password',
        pageBuilder: (context, state) =>
            _slideUp(const ForgotPasswordScreen(), state),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            AppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) =>
                    _fadeThrough(const HomeScreen(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/map',
                pageBuilder: (context, state) =>
                    _fadeThrough(const MachinesMapScreen(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/wallet',
                pageBuilder: (context, state) =>
                    _fadeThrough(const WalletScreen(), state),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                pageBuilder: (context, state) =>
                    _fadeThrough(const ProfileScreen(), state),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/scan',
        pageBuilder: (context, state) =>
            _slideUp(const ScanDepositScreen(), state),
      ),
      GoRoute(
        path: '/withdraw',
        pageBuilder: (context, state) =>
            _slideUp(const WithdrawScreen(), state),
      ),
      GoRoute(
        path: '/history',
        pageBuilder: (context, state) => _fade(const HistoryScreen(), state),
        routes: [
          GoRoute(
            path: ':id',
            pageBuilder: (context, state) => _fade(
              TransactionDetailScreen(id: state.pathParameters['id']!),
              state,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/referral',
        pageBuilder: (context, state) => _fade(const ReferralScreen(), state),
      ),
      GoRoute(
        path: '/notifications',
        pageBuilder: (context, state) =>
            _fade(const NotificationsScreen(), state),
      ),
      GoRoute(
        path: '/edit-profile',
        pageBuilder: (context, state) =>
            _fade(const EditProfileScreen(), state),
      ),
    ],
  );
});

CustomTransitionPage<void> _fade(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _fadeThrough(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, secondary, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: child,
      );
    },
  );
}

CustomTransitionPage<void> _slideUp(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 360),
    transitionsBuilder: (context, animation, secondary, child) {
      final offset = Tween<Offset>(
        begin: const Offset(0, 1),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));
      return SlideTransition(position: offset, child: child);
    },
  );
}

/// Bridges Riverpod settings changes into GoRouter refresh.
class _SettingsListenable extends ChangeNotifier {
  _SettingsListenable(this._ref) {
    _ref.listen(settingsProvider, (_, __) => notifyListeners());
    _ref.listen(authUserProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}
