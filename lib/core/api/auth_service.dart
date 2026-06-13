import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Production API URL configured for cPanel backend
  static const String baseUrl = 'https://alumni.recordly.ng/api';

  static Future<Map<String, dynamic>> register(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse("${AuthService.baseUrl}/register.php"),
        body: data,
      );
      return jsonDecode(response.body);
    } catch (e) { return {"success": false, "message": "Network Error"}; }
  }

  static Future<Map<String, dynamic>> login(String identifier, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'identifier': identifier,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['data'] != null) {
          await _saveSession(data['data']);
        }
        return data;
      } else {
        return {'success': false, 'message': 'Server error: ${response.statusCode}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error. Please check your connection.'};
    }
  }

  static Future<void> _saveSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('session_token', userData['token'] ?? '');
    await prefs.setString('role_slug', userData['role_slug'] ?? 'member');
    await prefs.setString('user_id', userData['id']?.toString() ?? '');
    await prefs.setString('full_name', userData['full_name'] ?? '');
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token');

    if (token != null) {
      try {
        await http.post(
          Uri.parse('$baseUrl/auth.php?action=logout'),
          headers: {'Authorization': 'Bearer $token'},
        );
      } catch (_) {
        // Proceed with local logout even if server is unreachable
      }
    }
    await prefs.clear();
  }

  static Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role_slug');
  }

  static Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth.php?action=google_login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        // Handle session if needed, typically SharedPreferences
      }
      return data;
    } catch (e) {
      return {'success': false, 'message': 'Network error occurred: $e'};
    }
  }
}
