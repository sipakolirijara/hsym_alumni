import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/role_dashboard_screen.dart';
import '../../features/finance/screens/submit_contribution_screen.dart';
import '../../features/finance/screens/contribution_history_screen.dart';
import '../../features/events/screens/events_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import 'splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/dashboard/:role', builder: (context, state) => RoleDashboardScreen(role: state.pathParameters['role'] ?? 'member')),
      GoRoute(path: '/submit-contribution', builder: (context, state) => const SubmitContributionScreen()),
      GoRoute(path: '/history', builder: (context, state) => const ContributionHistoryScreen()),
      GoRoute(path: '/events', builder: (context, state) => const EventsScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
    ],
  );
}
