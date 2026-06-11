import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/announcement_service.dart';
import '../../../shared/widgets/glass_container.dart';

class AnnouncementsScreen extends StatefulWidget {
  const AnnouncementsScreen({super.key});
  @override
  State<AnnouncementsScreen> createState() => _AnnouncementsScreenState();
}

class _AnnouncementsScreenState extends State<AnnouncementsScreen> {
  List<dynamic> _news = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await AnnouncementService.getAnnouncements();
    if (mounted && result['success'] == true) setState(() { _news = result['data']; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Latest News')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : _news.isEmpty
            ? const Center(child: Text('No announcements yet', style: TextStyle(color: Colors.black54)))
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _news.length,
                itemBuilder: (context, index) {
                  final item = _news[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassContainer(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.campaign, color: AppTheme.brandPrimary),
                              const SizedBox(width: 8),
                              Expanded(child: Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87))),
                            ],
                          ),
                          const Divider(),
                          Text(item['message'], style: const TextStyle(color: Colors.black87, height: 1.5)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('By: ${item['author'] ?? 'PRO'}', style: const TextStyle(color: AppTheme.brandPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                              Text('${item['created_at']}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
