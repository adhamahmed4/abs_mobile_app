// ignore_for_file: must_be_immutable
import 'dart:convert';

import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/FirebaseApi/firebase_api.dart';
import 'package:abs_mobile_app/Courier/Home/home.dart';
import 'package:abs_mobile_app/Courier/Maps/maps.dart';
import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:abs_mobile_app/l10n/l10n.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'ABS-MobileApp',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseApi().initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Title: ${message.notification!.title}');
    print('Body: ${message.notification!.body}');
    print('Message data: ${message.data}');
    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
    }
  });

  runApp(
    const MyApp(),
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final notification = message.notification;
  final data = message.data;

  print("Notification: $notification");
  print("Data: $data");
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
    AppConfig.setSelectedLanguage(newLocale);
  }

  static Locale getLocale(BuildContext context) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    return state._locale;
  }

  Future<void> backgroundNotifHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');
  int roleTypeID = 0;

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  Future<bool> checkTokenExistence() async {
    String? token = await AppConfig.checkToken();
    if (token != null) {
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('invalid token');
      }

      final payload = _decodeBase64(parts[1]);
      final payloadMap = json.decode(payload);
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('invalid payload');
      }

      roleTypeID = payloadMap["UserInfo"]["roleTypeID"];
    }
    return token != null;
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage');
    if (savedLanguage != null) {
      setState(() {
        _locale = Locale(savedLanguage);
        AppConfig.setSelectedLanguage(_locale);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
    var fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkTokenExistence(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final bool isTokenExists = snapshot.data ?? false;

          return MaterialApp(
            supportedLocales: L10n.all,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            locale: _locale,
            home: isTokenExists
                ? roleTypeID == 1
                    ? const HomePage()
                    : const NavBar()
                : LoginPage(),
            title: 'ABS Courier & Freight Systems',
            theme: ThemeData(
              primarySwatch: const MaterialColor(
                0xFF2B2E83,
                <int, Color>{
                  50: Color(0xFF2B2E83),
                  100: Color(0xFF2B2E83),
                  200: Color(0xFF2B2E83),
                  300: Color(0xFF2B2E83),
                  400: Color(0xFF2B2E83),
                  500: Color(0xFF2B2E83),
                  600: Color(0xFF2B2E83),
                  700: Color(0xFF2B2E83),
                  800: Color(0xFF2B2E83),
                  900: Color(0xFF2B2E83),
                },
              ),
              scaffoldBackgroundColor: Colors.white,
              fontFamily: GoogleFonts.openSans().fontFamily,
            ),
            debugShowCheckedModeBanner: false,
          );
        }
      },
    );
  }
}
