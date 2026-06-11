import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/secretary_service.dart';
import '../../../core/api/event_service.dart';
import '../../../shared/widgets/glass_container.dart';

class ManageEventsScreen extends StatefulWidget {
  const ManageEventsScreen({super.key});
  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  List<dynamic> _events = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchEvents(); }
  Future<void> _fetchEvents() async {
    final result = await EventService.getEvents();
    if (mounted && result['success'] == true) setState(() { _events = result['data']; _isLoading = false; });
  }

  void _showAddEventDialog() {
    final nameCtrl = TextEditingController();
    final dateCtrl = TextEditingController();
    final timeCtrl = TextEditingController();
    final venueCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish New Event'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Event Name')),
              TextField(controller: dateCtrl, decoration: const InputDecoration(labelText: 'Date (YYYY-MM-DD)')),
              TextField(controller: timeCtrl, decoration: const InputDecoration(labelText: 'Time (HH:MM AM/PM)')),
              TextField(controller: venueCtrl, decoration: const InputDecoration(labelText: 'Venue')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              final res = await SecretaryService.createEvent({
                'event_name': nameCtrl.text, 'event_date': dateCtrl.text,
                'event_time': timeCtrl.text, 'venue': venueCtrl.text,
              });
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
              _fetchEvents();
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Events')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.brandPrimary,
        onPressed: _showAddEventDialog,
        child: const Icon(Icons.add, color: Colors.white),
      ),
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
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(event['event_name'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    subtitle: Text('${event['event_date']} @ ${event['event_time']}\nVenue: ${event['venue']}', style: const TextStyle(color: Colors.black54)),
                    trailing: Text(event['status'].toUpperCase(), style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),
    );
  }
}
