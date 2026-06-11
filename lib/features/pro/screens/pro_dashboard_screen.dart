import '../../../shared/widgets/notification_bell.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/auth_service.dart';
import '../../../core/api/pro_service.dart';

class ProDashboardScreen extends StatefulWidget {
  const ProDashboardScreen({super.key});
  @override
  State<ProDashboardScreen> createState() => _ProDashboardScreenState();
}

class _ProDashboardScreenState extends State<ProDashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await ProService.getDashboard();
    if (mounted && result['success'] == true) setState(() { _stats = result['data']; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PRO Workspace'), 
        actions: [ const NotificationBell(),
          IconButton(icon: const Icon(Icons.logout), onPressed: () async { await AuthService.logout(); if (context.mounted) context.go('/login'); })
        ],
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              _buildStatCard('Total Broadcasts', '${_stats?['total_announcements'] ?? 0}', Icons.campaign, AppTheme.brandPrimary),
              const SizedBox(height: 32),
              const Text('Public Relations Actions', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24, runSpacing: 24, alignment: WrapAlignment.start,
                children: [
                  _buildCircularAction(context, Icons.podcasts, 'Broadcasts', () => context.push('/pro/announcements')),
                  _buildCircularAction(context, Icons.event, 'Events', () => context.push('/events')),
                  _buildCircularAction(context, Icons.photo_library, 'Gallery', () => context.push('/gallery')),
                ],
              ),
              const SizedBox(height: 32),
              const Text('My Personal Account', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Wrap(
                spacing: 24, runSpacing: 24, alignment: WrapAlignment.start,
                children: [
                  _buildCircularAction(context, Icons.payments_outlined, 'Pay Dues', () => context.push('/submit-contribution')),
                  _buildCircularAction(context, Icons.history, 'My History', () => context.push('/history')),
                  _buildCircularAction(context, Icons.person_outline, 'Profile', () => context.push('/profile')),
                ],
              ),
            ],
          ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32), const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          Text(title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildCircularAction(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60, width: 60,
              decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: AppTheme.brandPrimary.withOpacity(0.2)), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
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
