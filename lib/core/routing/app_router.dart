import 'package:go_router/go_router.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/dashboard/screens/role_dashboard_screen.dart';
import '../../features/finance/screens/submit_contribution_screen.dart';
import '../../features/finance/screens/contribution_history_screen.dart';
import '../../features/events/screens/events_screen.dart';
import '../../features/profile/screens/profile_screen.dart';
import '../../features/treasurer/screens/verifications_screen.dart';
import '../../features/treasurer/screens/contributions_screen.dart';
import '../../features/gallery/screens/gallery_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/profile/screens/change_password_screen.dart';
import '../../features/president/screens/directory_screen.dart';
import '../../features/president/screens/president_ledger_screen.dart';
import '../../features/secretary/screens/manage_events_screen.dart';
import '../../features/pro/screens/manage_announcements_screen.dart';
import '../../features/announcements/screens/announcements_screen.dart';
import '../../features/finsec/screens/finsec_dashboard_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import 'splash_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/dashboard/:role', builder: (context, state) => RoleDashboardScreen(role: state.pathParameters['role'] ?? 'member')),
      GoRoute(path: '/submit-contribution', builder: (context, state) => const SubmitContributionScreen()),
      GoRoute(path: '/history', builder: (context, state) => const ContributionHistoryScreen()),
      GoRoute(path: '/events', builder: (context, state) => const EventsScreen()),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/gallery', builder: (context, state) => const GalleryScreen()),
      GoRoute(path: '/edit-profile', builder: (context, state) => EditProfileScreen(profile: state.extra as Map<String, dynamic>)),
      GoRoute(path: '/change-password', builder: (context, state) => const ChangePasswordScreen()),
      GoRoute(path: '/notifications', builder: (context, state) => const NotificationsScreen()),
      GoRoute(path: '/announcements', builder: (context, state) => const AnnouncementsScreen()),
      GoRoute(path: '/president/directory', builder: (context, state) => const DirectoryScreen()),
      GoRoute(path: '/president/ledger', builder: (context, state) => const PresidentLedgerScreen()),
      GoRoute(path: '/secretary/manage-events', builder: (context, state) => const ManageEventsScreen()),
      GoRoute(path: '/pro/announcements', builder: (context, state) => const ManageAnnouncementsScreen()),
      GoRoute(path: '/treasurer/verifications', builder: (context, state) => const VerificationsScreen()),
      GoRoute(path: '/treasurer/contributions', builder: (context, state) => const ContributionsScreen()),
    ],
  );
}
