// ignore_for_file: must_be_immutable
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:abs_mobile_app/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MyApp(),
  );
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

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  void setLocale(Locale newLocale) {
    setState(() {
      _locale = newLocale;
    });
  }

  Future<bool> checkTokenExistence() async {
    String? token = await AppConfig.checkToken();
    return token != null;
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('selectedLanguage');
    if (savedLanguage != null) {
      setState(() {
        _locale = Locale(savedLanguage);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
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
            home: isTokenExists ? const NavBar() : LoginPage(),
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
