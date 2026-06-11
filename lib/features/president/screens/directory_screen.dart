import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/president_service.dart';

class DirectoryScreen extends StatefulWidget {
  const DirectoryScreen({super.key});
  @override
  State<DirectoryScreen> createState() => _DirectoryScreenState();
}

class _DirectoryScreenState extends State<DirectoryScreen> {
  List<dynamic> _members = [];
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchData(); }
  Future<void> _fetchData() async {
    final result = await PresidentService.getDirectory();
    if (mounted && result['success'] == true) setState(() { _members = result['data']; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Member Directory')),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _members.length,
            itemBuilder: (context, index) {
              final member = _members[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: GlassContainer(
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(backgroundColor: AppTheme.brandPrimary, child: Icon(Icons.person, color: Colors.white)),
                    title: Text('${member['full_name']} (${member['member_no']})', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    subtitle: Text('${member['occupation'] ?? 'No occupation'}\n${member['phone'] ?? 'No phone'}', style: const TextStyle(color: Colors.black54)),
                  ),
                ),
              );
            },
          ),
    );
  }
}
