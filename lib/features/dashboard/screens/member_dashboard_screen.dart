import '../../../shared/widgets/notification_bell.dart';
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
        title: const Text('Member Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [ const NotificationBell(),
          IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: () async { await AuthService.logout(); if (context.mounted) context.go('/login'); })
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          GlassContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(color: Colors.black54, fontSize: 16)),
                const SizedBox(height: 8),
                Text(_fullName, style: const TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('Quick Actions', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.start,
            children: [
              _buildCircularAction(context, icon: Icons.payments_outlined, title: 'Pay Dues', onTap: () => context.push('/submit-contribution')),
              _buildCircularAction(context, icon: Icons.history, title: 'History', onTap: () => context.push('/history')),
              _buildCircularAction(context, icon: Icons.campaign, title: 'News', onTap: () => context.push('/announcements')),
              _buildCircularAction(context, icon: Icons.event, title: 'Events', onTap: () => context.push('/events')),
              _buildCircularAction(context, icon: Icons.photo_library, title: 'Gallery', onTap: () => context.push('/gallery')),
              _buildCircularAction(context, icon: Icons.person_outline, title: 'Profile', onTap: () => context.push('/profile')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCircularAction(BuildContext context, {required IconData icon, required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60, width: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.2)),
              ),
              child: Icon(icon, size: 28, color: AppTheme.brandPrimary),
            ),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
