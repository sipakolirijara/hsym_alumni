import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_service.dart';

class FinanceService {
  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('session_token') ?? '';
    return {'Authorization': 'Bearer $token', 'Accept': 'application/json'};
  }

  static Future<Map<String, dynamic>> getCurrentPeriod() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/finance.php?action=current'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }

  static Future<Map<String, dynamic>> getHistory() async {
    try {
      final response = await http.get(Uri.parse('${AuthService.baseUrl}/finance.php?action=history'), headers: await _getHeaders());
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }

  static Future<Map<String, dynamic>> submitPayment({
    required String contributionId, required String amount, required String paymentMethod,
    required String reference, required String notes, XFile? proofFile,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      var request = http.MultipartRequest('POST', Uri.parse('${AuthService.baseUrl}/finance.php?action=submit'));
      request.headers['Authorization'] = 'Bearer ${prefs.getString('session_token') ?? ''}';
      request.fields['contribution_id'] = contributionId;
      request.fields['amount'] = amount;
      request.fields['payment_method'] = paymentMethod;
      request.fields['transaction_reference'] = reference;
      request.fields['notes'] = notes;
      if (proofFile != null) request.files.add(await http.MultipartFile.fromPath('proof_file', proofFile.path));
      var streamedResponse = await request.send();
      return jsonDecode((await http.Response.fromStream(streamedResponse)).body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }
}
