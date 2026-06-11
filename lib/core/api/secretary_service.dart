import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class SecretaryService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/secretary.php?action=dashboard'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> createEvent(Map<String, String> data) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/secretary.php?action=create_event'),
        headers: await _getHeaders(), body: jsonEncode(data),
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }
}
