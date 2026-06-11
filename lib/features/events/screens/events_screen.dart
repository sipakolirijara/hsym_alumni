import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/event_service.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});
  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchEvents(); }

  Future<void> _fetchEvents() async {
    final result = await EventService.getEvents();
    if (result['success'] == true && mounted) {
      setState(() { _events = result['data']; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Alumni Events'), backgroundColor: AppTheme.darkBackground),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _events.length,
            itemBuilder: (context, index) {
              final event = _events[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(event['event_name'], style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text('Date: ${event['event_date']} - ${event['event_time'] ?? ''}', style: const TextStyle(color: Colors.black54)),
                      Text('Venue: ${event['venue'] ?? 'TBA'}', style: const TextStyle(color: Colors.black54)),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: AppTheme.brandPrimary.withOpacity(0.2), borderRadius: BorderRadius.circular(4)),
                        child: Text(event['status'].toUpperCase(), style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
