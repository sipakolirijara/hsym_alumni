import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/api/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  final Map<String, dynamic> profile;
  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _fnCtrl;
  late TextEditingController _lnCtrl;
  late TextEditingController _phCtrl;
  late TextEditingController _emCtrl;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _fnCtrl = TextEditingController(text: widget.profile['first_name']);
    _lnCtrl = TextEditingController(text: widget.profile['last_name']);
    _phCtrl = TextEditingController(text: widget.profile['phone']);
    _emCtrl = TextEditingController(text: widget.profile['email']);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    final res = await UserService.updateProfile({
      'first_name': _fnCtrl.text, 'last_name': _lnCtrl.text,
      'phone': _phCtrl.text, 'email': _emCtrl.text,
    });
    setState(() => _isSaving = false);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res['message'])));
      if (res['success'] == true) context.pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          TextField(controller: _fnCtrl, decoration: const InputDecoration(labelText: 'First Name'), style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 16),
          TextField(controller: _lnCtrl, decoration: const InputDecoration(labelText: 'Last Name'), style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 16),
          TextField(controller: _phCtrl, decoration: const InputDecoration(labelText: 'Phone'), style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 16),
          TextField(controller: _emCtrl, decoration: const InputDecoration(labelText: 'Email'), style: const TextStyle(color: Colors.black87)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving ? const CircularProgressIndicator(color: Colors.black87) : const Text('Save Changes'),
          )
        ],
      ),
    );
  }
}
