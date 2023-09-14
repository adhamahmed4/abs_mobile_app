import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {
  static const String baseUrl = 'http://192.168.1.8:3000';
  static String? jwtToken;

  static Future<void> storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", token);
  }

  static Future<void> initialize() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      jwtToken = prefs.getString("accessToken");
    } catch (e) {
      print(e);
    }
  }

  static Map<String, String> get headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    return headers;
  }
}
