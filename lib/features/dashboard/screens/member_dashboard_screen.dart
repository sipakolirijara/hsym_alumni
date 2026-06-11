import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/auth_service.dart';

class MemberDashboardScreen extends StatefulWidget {
  const MemberDashboardScreen({super.key});
  @override
  State<MemberDashboardScreen> createState() => _MemberDashboardScreenState();
}

class _MemberDashboardScreenState extends State<MemberDashboardScreen> {
  String _fullName = 'Loading...';

  @override
  void initState() { super.initState(); _loadUserData(); }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() { _fullName = prefs.getString('full_name') ?? 'Alumni Member'; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.darkBackground,
        title: const Text('Member Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () async { await AuthService.logout(); if (context.mounted) context.go('/login'); },
          )
        ],
      ),
      backgroundColor: AppTheme.darkBackground,
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(color: Colors.white70, fontSize: 16)),
                const SizedBox(height: 8),
                Text(_fullName, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Quick Actions', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            children: [
              _buildActionCard(context, icon: Icons.payments_outlined, title: 'Pay Dues', onTap: () => context.push('/submit-contribution')),
              _buildActionCard(context, icon: Icons.history, title: 'History', onTap: () => context.push('/history')),
              _buildActionCard(context, icon: Icons.event, title: 'Events', onTap: () => context.push('/events')),
              _buildActionCard(context, icon: Icons.person_outline, title: 'Profile', onTap: () => context.push('/profile')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 42, color: AppTheme.brandPrimary),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
