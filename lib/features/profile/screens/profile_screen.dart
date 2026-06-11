import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/widgets/glass_container.dart';
import '../../../core/api/user_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() { super.initState(); _fetchProfile(); }

  Future<void> _fetchProfile() async {
    final result = await UserService.getProfile();
    if (result['success'] == true && mounted) {
      setState(() { _profile = result['data']; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile'), backgroundColor: AppTheme.darkBackground),
      backgroundColor: AppTheme.darkBackground,
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppTheme.brandPrimary))
        : SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(child: Icon(Icons.account_circle, size: 80, color: AppTheme.brandPrimary)),
                  const SizedBox(height: 16),
                  _buildRow('Name', _profile?['full_name'] ?? ''),
                  _buildRow('Member No', _profile?['member_no'] ?? ''),
                  _buildRow('Email', _profile?['email'] ?? 'N/A'),
                  _buildRow('Phone', _profile?['phone'] ?? ''),
                  _buildRow('Occupation', _profile?['occupation'] ?? 'Not specified'),
                  _buildRow('State', _profile?['state'] ?? 'Not specified'),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 16)),
          const Divider(color: AppTheme.glassBorder),
        ],
      ),
    );
  }
}
