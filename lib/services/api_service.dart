import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.56.1:8080';

  static Future<Map<String, dynamic>> post(String path, Map body) async {
    final url = Uri.parse('$baseUrl$path');
    final res = await http.post(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> get(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final res = await http.get(url, headers: {'Content-Type': 'application/json'});
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> put(String path, Map body) async {
    final url = Uri.parse('$baseUrl$path');
    final res = await http.put(url, headers: {'Content-Type': 'application/json'}, body: jsonEncode(body));
    return _parseResponse(res);
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final url = Uri.parse('$baseUrl$path');
    final res = await http.delete(url, headers: {'Content-Type': 'application/json'});
    return _parseResponse(res);
  }

  static Map<String, dynamic> _parseResponse(http.Response res) {
    try {
      final decoded = jsonDecode(res.body);
      if (decoded is Map<String, dynamic>) return decoded;
      return {'code': res.statusCode, 'status': false, 'data': decoded};
    } catch (e) {
      return {'code': res.statusCode, 'status': false, 'data': 'Invalid response body'};
    }
  }

  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
