import 'dart:ui';

import 'package:shared_preferences/shared_preferences.dart';

class AppConfig {

  static const String baseUrl = 'http://192.168.137.1:3000';
  static String? jwtToken;
  static Locale? _selectedLanguage;

  static void setSelectedLanguage(Locale locale) {
    _selectedLanguage = locale;
  }

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

  static Future<String?> checkToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      jwtToken = prefs.getString("accessToken");
      return jwtToken!;
    } catch (e) {
      print(e);
    }
    return null;
  }

  static Future<void> saveFcmToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("fcmToken", token);
  }

  static Map<String, String> get headers {
    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $jwtToken'
    };

    headers['Accept-Language'] = _selectedLanguage!.languageCode;

    return headers;
  }
}
