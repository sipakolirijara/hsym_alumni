import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
    setState(() => _isLoading = true);
    final result = await UserService.getProfile();
    if (result['success'] == true && mounted) {
      setState(() { _profile = result['data']; _isLoading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
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
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final changed = await context.push<bool>('/edit-profile', extra: _profile);
                            if (changed == true) _fetchProfile();
                          },
                          child: const Text('Edit Profile', style: TextStyle(color: AppTheme.brandPrimary)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => context.push('/change-password'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text('Change Password'),
                        ),
                      ),
                    ],
                  )
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
          Text(label, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          Text(value, style: const TextStyle(color: Colors.black87, fontSize: 16)),
          const Divider(color: AppTheme.glassBorder),
        ],
      ),
    );
  }
}
