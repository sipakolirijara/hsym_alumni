import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/api/notification_service.dart';

class NotificationBell extends StatefulWidget {
  const NotificationBell({super.key});
  @override
  State<NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<NotificationBell> {
  int _unreadCount = 0;

  @override
  void initState() { super.initState(); _fetchCount(); }

  Future<void> _fetchCount() async {
    final count = await NotificationService.getUnreadCount();
    if (mounted) setState(() { _unreadCount = count; });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.notifications, color: Colors.white),
          onPressed: () async {
            await context.push('/notifications');
            _fetchCount(); // Refresh count when coming back
          },
        ),
        if (_unreadCount > 0)
          Positioned(
            right: 8, top: 8,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle),
              child: Text('$_unreadCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}
