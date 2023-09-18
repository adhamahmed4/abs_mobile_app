// ignore_for_file: must_be_immutable

import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> checkTokenExistence() async {
    String? token = await AppConfig.checkToken();
    return token != null;
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
            initialRoute: '/',
            routes: {
              '/': (context) => isTokenExists ? const NavBar() : LoginPage(),
            },
          );
        }
      },
    );
  }
}
