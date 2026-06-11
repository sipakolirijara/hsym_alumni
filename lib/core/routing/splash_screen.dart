import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../../shared/widgets/glass_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndRoute();
  }

  Future<void> _checkAuthAndRoute() async {
    // Brief delay to ensure UI renders smoothly and allows reading the branding
    await Future.delayed(const Duration(milliseconds: 1500));
    
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');
    final roleSlug = prefs.getString('role_slug');

    if (mounted) {
      if (token != null && token.isNotEmpty && roleSlug != null) {
        // Valid session found, route to specific role dashboard
        context.go('/dashboard/$roleSlug');
      } else {
        // No session, route to login
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1E1E1E), Color(0xFF000000)],
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: GlassContainer(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.school, size: 64, color: AppTheme.primaryPurple),
                  SizedBox(height: 24),
                  Text(
                    'GPS Alumni Connect',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Verifying clearance level...',
                    style: TextStyle(color: Colors.white70),
                  ),
                  SizedBox(height: 32),
                  CircularProgressIndicator(color: AppTheme.primaryPurple),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
