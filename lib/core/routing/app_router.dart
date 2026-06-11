import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/role_dashboard_screen.dart';
import 'splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard/:role',
        builder: (context, state) {
          final role = state.pathParameters['role'] ?? 'member';
          return RoleDashboardScreen(role: role);
        },
      ),
    ],
  );
}
