import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class PresidentService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/president.php?action=dashboard'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> getDirectory() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/president.php?action=directory'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> getGlobalLedger() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/president.php?action=ledger'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }
}
