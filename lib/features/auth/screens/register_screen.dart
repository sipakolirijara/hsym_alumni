import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/api/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fnCtrl = TextEditingController();
  final _lnCtrl = TextEditingController();
  final _phCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();
    if (_fnCtrl.text.isEmpty || _lnCtrl.text.isEmpty || _phCtrl.text.isEmpty || _pwCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields')));
      return;
    }
    setState(() => _isLoading = true);
    final result = await AuthService.register({
      'first_name': _fnCtrl.text.trim(), 'last_name': _lnCtrl.text.trim(),
      'phone': _phCtrl.text.trim(), 'password': _pwCtrl.text,
    });
    setState(() => _isLoading = false);
    
    if (result['success'] == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Registration successful. Pending admin approval.'), backgroundColor: Colors.green));
      context.pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Registration failed'), backgroundColor: Colors.redAccent));
    }
  }

  Widget _buildCustomInput({required IconData icon, required String label, required TextEditingController controller, required bool isDark, bool isPassword = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.08), shape: BoxShape.circle),
          child: Icon(icon, color: AppTheme.primaryColor, size: 22),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
              TextField(
                controller: controller,
                obscureText: isPassword ? _obscurePassword : false,
                style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 16, fontWeight: FontWeight.w500),
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5)),
                  focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.primaryColor, width: 2)),
                  suffixIconConstraints: const BoxConstraints(maxHeight: 32, maxWidth: 32),
                  suffixIcon: isPassword 
                    ? IconButton(padding: EdgeInsets.zero, icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey.shade400, size: 20), onPressed: () => setState(() => _obscurePassword = !_obscurePassword))
                    : null,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBackgroundColor : Colors.white,
      appBar: AppBar(leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop())),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Join Alumni HYSM', textAlign: TextAlign.center, style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black)),
              const SizedBox(height: 8),
              Text('Create an account to stay connected', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
              const SizedBox(height: 40),
              
              _buildCustomInput(icon: Icons.person_rounded, label: 'First Name', controller: _fnCtrl, isDark: isDark),
              const SizedBox(height: 24),
              _buildCustomInput(icon: Icons.person_rounded, label: 'Last Name', controller: _lnCtrl, isDark: isDark),
              const SizedBox(height: 24),
              _buildCustomInput(icon: Icons.phone_rounded, label: 'Phone Number', controller: _phCtrl, isDark: isDark),
              const SizedBox(height: 24),
              _buildCustomInput(icon: Icons.lock_rounded, label: 'Password (min 6 chars)', controller: _pwCtrl, isDark: isDark, isPassword: true),
              const SizedBox(height: 40),
              
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 0),
                  child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Complete Registration', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
