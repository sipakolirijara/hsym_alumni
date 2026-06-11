import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/auth_service.dart';
import '../../../core/api/treasurer_service.dart';

class TreasurerDashboardScreen extends StatefulWidget {
  const TreasurerDashboardScreen({super.key});
  @override
  State<TreasurerDashboardScreen> createState() => _TreasurerDashboardScreenState();
}

class _TreasurerDashboardScreenState extends State<TreasurerDashboardScreen> {
  Map<String, dynamic>? _stats;
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await TreasurerService.getDashboard();
    if (mounted && result['success'] == true) setState(() { _stats = result['data']; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Treasurer Workspace'), 
        actions: [
          IconButton(icon: const Icon(Icons.logout, color: Colors.black87), onPressed: () async { await AuthService.logout(); if (context.mounted) context.go('/login'); })
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Row(
                children: [
                  Expanded(child: _buildStatCard('Pending', '${_stats?['pending_count'] ?? 0}', Icons.pending_actions, Colors.orange)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildStatCard('Members', '${_stats?['member_count'] ?? 0}', Icons.people, AppTheme.brandPrimary)),
                ],
              ),
              const SizedBox(height: 32),
              const Text('Admin Actions', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
                children: [
                  _buildAction(context, Icons.verified, 'Verifications', () => context.push('/treasurer/verifications')),
                  _buildAction(context, Icons.account_balance_wallet, 'Ledger', () => context.push('/treasurer/contributions')),
                  _buildAction(context, Icons.photo_library, 'Gallery', () => context.push('/gallery')),
                ],
              ),
              const SizedBox(height: 32),
              const Text('My Personal Account', style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              GridView.count(
                shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16,
                children: [
                  _buildAction(context, Icons.payments_outlined, 'Pay My Dues', () => context.push('/submit-contribution')),
                  _buildAction(context, Icons.history, 'My History', () => context.push('/history')),
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
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAction(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: AppTheme.brandPrimary), const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
