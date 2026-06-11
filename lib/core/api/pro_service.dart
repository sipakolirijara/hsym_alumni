import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class ProService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/pro.php?action=dashboard'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> getAnnouncements() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/pro.php?action=list_announcements'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> createAnnouncement(String title, String message) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/pro.php?action=create_announcement'),
        headers: await _getHeaders(), body: jsonEncode({'title': title, 'message': message}),
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }
}
