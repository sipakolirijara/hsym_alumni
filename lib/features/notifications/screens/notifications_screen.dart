import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/notification_service.dart';
import '../../../shared/widgets/glass_container.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});
  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<dynamic> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }

  Future<void> _fetchData() async {
    final alerts = await NotificationService.getNotifications();
    if (mounted) setState(() { _alerts = alerts; _isLoading = false; });
    await NotificationService.markAllAsRead();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : _alerts.isEmpty
            ? const Center(child: Text('You have no new alerts', style: TextStyle(color: Colors.black54)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _alerts.length,
                itemBuilder: (context, index) {
                  final alert = _alerts[index];
                  final isRead = alert['is_read'] == 1 || alert['is_read'] == '1';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          backgroundColor: isRead ? Colors.grey[300] : AppTheme.brandPrimary.withOpacity(0.2),
                          child: Icon(Icons.notifications_active, color: isRead ? Colors.grey : AppTheme.brandPrimary),
                        ),
                        title: Text(alert['title'], style: TextStyle(fontWeight: isRead ? FontWeight.normal : FontWeight.bold, color: Colors.black87)),
                        subtitle: Text(alert['message'], style: const TextStyle(color: Colors.black54)),
                        trailing: Text(alert['created_at'].toString().split(' ')[0], style: const TextStyle(fontSize: 10, color: Colors.black38)),
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
