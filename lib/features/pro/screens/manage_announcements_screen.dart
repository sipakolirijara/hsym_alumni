import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/pro_service.dart';
import '../../../shared/widgets/glass_container.dart';

class ManageAnnouncementsScreen extends StatefulWidget {
  const ManageAnnouncementsScreen({super.key});
  @override
  State<ManageAnnouncementsScreen> createState() => _ManageAnnouncementsScreenState();
}

class _ManageAnnouncementsScreenState extends State<ManageAnnouncementsScreen> {
  List<dynamic> _news = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await ProService.getAnnouncements();
    if (mounted && result['success'] == true) setState(() { _news = result['data']; _isLoading = false; });
  }

  void _showAddDialog() {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Broadcast'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Headline Title')),
              const SizedBox(height: 16),
              TextField(controller: msgCtrl, maxLines: 4, decoration: const InputDecoration(labelText: 'Broadcast Message', border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              setState(() => _isLoading = true);
              final res = await ProService.createAnnouncement(titleCtrl.text, msgCtrl.text);
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
              _fetchData();
            },
            child: const Text('Send Broadcast'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Broadcasts')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppTheme.brandPrimary,
        onPressed: _showAddDialog,
        child: const Icon(Icons.campaign, color: Colors.white),
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final item = _news[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text(item['message'], style: const TextStyle(color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text('Broadcasted on: ${item['created_at']}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }
}
