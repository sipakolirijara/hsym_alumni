import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/users.php?action=profile'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }

  static Future<Map<String, dynamic>> updateProfile(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/users.php?action=update_profile'),
        headers: await _getHeaders(), body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }

  static Future<Map<String, dynamic>> changePassword(String current, String newPass) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/users.php?action=change_password'),
        headers: await _getHeaders(), body: jsonEncode({'current_password': current, 'new_password': newPass}),
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }
}
