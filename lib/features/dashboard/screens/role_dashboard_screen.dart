import '../../president/screens/president_dashboard_screen.dart';
import '../../treasurer/screens/treasurer_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/auth_service.dart';

// Import our specific role dashboards
import 'member_dashboard_screen.dart';

class RoleDashboardScreen extends StatelessWidget {
  final String role;
  const RoleDashboardScreen({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    // Intercept the role and route to the strict module
    switch (role) {
      case 'president':
        return const PresidentDashboardScreen();

      case 'treasurer':
        return const TreasurerDashboardScreen();

      case 'member':
        return const MemberDashboardScreen();
      
      // As we build more modules (Treasurer, President, etc.), we add their cases here.
      case 'president':
        return const PresidentDashboardScreen();

      // case 'treasurer':
      //   return const TreasurerDashboardScreen();
        
      default:
        return _buildFallbackDashboard(context);
    }
  }

  // Fallback for roles we haven't built dedicated screens for yet
  Widget _buildFallbackDashboard(BuildContext context) {
    final displayRole = role.replaceAll('-', ' ').toUpperCase();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.lightBackground,
        elevation: 0,
        title: Text('$displayRole DASHBOARD', style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async {
              await AuthService.logout();
              if (context.mounted) context.go('/login');
            },
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppTheme.lightBackground, Color(0xFFE5E7EB)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.admin_panel_settings, size: 64, color: AppTheme.brandPrimary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to the $displayRole Workspace',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your specific mobile UI is currently under construction.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
