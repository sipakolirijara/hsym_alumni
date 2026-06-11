import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class TreasurerService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    return {'Authorization': 'Bearer ${prefs.getString('session_token') ?? ''}', 'Content-Type': 'application/json'};
  }

  static Future<Map<String, dynamic>> getDashboard() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/treasurer.php?action=dashboard'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> getPendingVerifications() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/treasurer.php?action=verifications'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> verifyPayment(String submissionId, String status, String remarks) async {
    try {
      final response = await http.post(
        Uri.parse('${AuthService.baseUrl}/treasurer.php?action=verify_action'),
        headers: await _getHeaders(),
        body: jsonEncode({'submission_id': submissionId, 'status': status, 'remarks': remarks}),
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }

  static Future<Map<String, dynamic>> getAllContributions() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/treasurer.php?action=contributions'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error'}; }
  }
}
