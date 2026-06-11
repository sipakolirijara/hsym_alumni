import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class UserService {
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('session_token') ?? '';
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/users.php?action=profile'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }
}
