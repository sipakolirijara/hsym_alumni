import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/user_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});
  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  bool _isSaving = false;

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final res = await UserService.changePassword(_currCtrl.text, _newCtrl.text);
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      if (res['success'] == true) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _currCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'Current Password'), style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 16),
          TextField(controller: _newCtrl, obscureText: true, decoration: const InputDecoration(labelText: 'New Password (min 6 chars)'), style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : const Text('Update Password'),
          )
        ],
      ),
    );
  }
}
