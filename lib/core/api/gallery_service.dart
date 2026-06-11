import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart';

class GalleryService {
  static Future<bool> uploadMedia(String albumId, String path) async {
    // Implementation for Media Director
    return true;
  }

  static Future<Map<String, dynamic>> getGallery() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('session_token') ?? '';
      final response = await http.get(
        Uri.parse('${AuthService.baseUrl}/gallery.php'),
        headers: {'Authorization': 'Bearer $token'},
      );
      return jsonDecode(response.body);
    } catch (e) { return {'success': false, 'message': 'Network error.'}; }
  }
}
