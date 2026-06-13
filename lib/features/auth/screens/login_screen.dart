
import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';

import 'package:google_sign_in/google_sign_in.dart';

import '../../../core/theme/app_theme.dart';

import '../../../core/api/auth_service.dart';



class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override

  State<LoginScreen> createState() => _LoginScreenState();

}



class _LoginScreenState extends State<LoginScreen> {

  final _identifierController = TextEditingController();

  final _passwordController = TextEditingController();

  bool _isLoading = false;

  bool _obscurePassword = true;



  Future<void> _handleLogin() async {

    FocusScope.of(context).unfocus();

    if (_identifierController.text.isEmpty || _passwordController.text.isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all fields')));

      return;

    }

    setState(() => _isLoading = true);

    final result = await AuthService.login(_identifierController.text.trim(), _passwordController.text);

    setState(() => _isLoading = false);

    

    if (result['success'] == true && mounted) {

      final role = await AuthService.getUserRole();

      context.go('/dashboard/${role ?? 'member'}');

    } else if (mounted) {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result['message'] ?? 'Login failed'), backgroundColor: Colors.redAccent));

    }

  }



  Future<void> _handleGoogleLogin() async {

    try {

      setState(() => _isLoading = true);

      // NOTE: Replace the string below with your actual WEB Client ID from Google Cloud Console

      final GoogleSignIn googleSignIn = GoogleSignIn(

        clientId: '247109397193-cacendm12kjh4ji3fl8blgp5jn4efpm6.apps.googleusercontent.com',
        serverClientId: '247109397193-cacendm12kjh4ji3fl8blgp5jn4efpm6.apps.googleusercontent.com', 

      );

      

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {

        setState(() => _isLoading = false);

        return; // User canceled

      }

      

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final String? idToken = googleAuth.idToken;

      

      if (idToken != null) {

        final result = await AuthService.googleLogin(idToken);

        setState(() => _isLoading = false);

        

        if (result['success'] == true && mounted) {

           final role = await AuthService.getUserRole();

           context.go('/dashboard/${role ?? 'member'}');

        } else if (mounted) {

           ScaffoldMessenger.of(context).showSnackBar(SnackBar(

             content: Text(result['message'] ?? 'Google Login failed', style: const TextStyle(fontWeight: FontWeight.bold)), 

             backgroundColor: Colors.redAccent,

             duration: const Duration(seconds: 4),

           ));

           await googleSignIn.signOut(); // Clear session so they can retry after registering

        }

      }

    } catch (e) {

      setState(() => _isLoading = false);

      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Google Sign-In Error: $e'), backgroundColor: Colors.redAccent));

    }

  }



  Widget _buildCustomInput({required IconData icon, required String label, required TextEditingController controller, required bool isDark, bool isPassword = false}) {

    return TextFormField(

      controller: controller,

      obscureText: isPassword && _obscurePassword,

      style: TextStyle(color: isDark ? Colors.white : Colors.black87),

      decoration: InputDecoration(

        labelText: label,

        labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),

        prefixIcon: Icon(icon, color: AppTheme.primaryColor),

        suffixIcon: isPassword ? IconButton(icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _obscurePassword = !_obscurePassword)) : null,

        filled: true,

        fillColor: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),

        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2)),

      ),

    );

  }



  @override

  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(

      backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,

      body: SafeArea(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24.0),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              const SizedBox(height: 40),

              Container(

                height: 100, width: 100,

                decoration: BoxDecoration(color: AppTheme.primaryColor.withOpacity(0.1), shape: BoxShape.circle),

                child: const Icon(Icons.school_rounded, size: 50, color: AppTheme.primaryColor),

              ),

              const SizedBox(height: 32),

              Text('Welcome Back', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : Colors.black87)),

              const SizedBox(height: 8),

              Text('Sign in to continue to AMS Connect', textAlign: TextAlign.center, style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),

              const SizedBox(height: 40),

              

              _buildCustomInput(icon: Icons.badge_rounded, label: 'Email or Member No', controller: _identifierController, isDark: isDark),

              const SizedBox(height: 24),

              _buildCustomInput(icon: Icons.lock_rounded, label: 'Password', controller: _passwordController, isDark: isDark, isPassword: true),

              const SizedBox(height: 40),

              

              SizedBox(

                height: 52,

                child: ElevatedButton(

                  onPressed: _isLoading ? null : _handleLogin,

                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), elevation: 0),

                  child: _isLoading ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),

                ),

              ),

              

              const SizedBox(height: 24),

              Row(

                children: [

                  Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),

                  Padding(

                    padding: const EdgeInsets.symmetric(horizontal: 16),

                    child: Text('OR', style: TextStyle(color: Colors.grey.shade500, fontWeight: FontWeight.bold)),

                  ),

                  Expanded(child: Divider(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300)),

                ],

              ),

              const SizedBox(height: 24),

              

              SizedBox(

                height: 52,

                child: OutlinedButton.icon(

                  onPressed: _isLoading ? null : _handleGoogleLogin,

                  icon: Image.network('https://upload.wikimedia.org/wikipedia/commons/c/c1/Google_%22G%22_logo.svg', height: 24),

                  label: const Text('Sign In with Google', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),

                  style: OutlinedButton.styleFrom(

                    foregroundColor: isDark ? Colors.white : Colors.black87,

                    side: BorderSide(color: isDark ? Colors.grey.shade800 : Colors.grey.shade300),

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),

                  ),

                ),

              ),



              const SizedBox(height: 40),

              Row(

                mainAxisAlignment: MainAxisAlignment.center,

                children: [

                  Text("Don't have an account?", style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade700, fontWeight: FontWeight.w600, fontSize: 14)),

                  TextButton(

                    onPressed: () => context.push('/register'),

                    child: const Text('Register Here', style: TextStyle(color: AppTheme.primaryColor, fontWeight: FontWeight.bold, fontSize: 15)),

                  ),

                ],

              ),

            ],

          ),

        ),

      ),

    );

  }

}

