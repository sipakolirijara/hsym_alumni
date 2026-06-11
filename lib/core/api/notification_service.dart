import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class NotificationService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<int> getUnreadCount() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/notifications.php?action=count'), headers: await _getHeaders());
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['data']['unread'];
      return 0;
    } catch (e) { return 0; }
  }

  static Future<List<dynamic>> getNotifications() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/notifications.php?action=list'), headers: await _getHeaders());
      final data = jsonDecode(response.body);
      if (data['success'] == true) return data['data'];
      return [];
    } catch (e) { return []; }
  }

  static Future<void> markAllAsRead() async {
    try {
      await http.get(Uri.parse('${AuthService.baseUrl}/notifications.php?action=mark_read'), headers: await _getHeaders());
    } catch (e) {}
  }
}
