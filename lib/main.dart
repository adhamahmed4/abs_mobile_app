import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'Configurations/app_config.dart';
import 'Login/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a MaterialColor using the desired color value
    MaterialColor primarySwatchColor = const MaterialColor(
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
    );

    // Define Font
    GoogleFonts.lexend();
    return MaterialApp(
      title: 'ABS Courier & Freight Systems',
      theme: ThemeData(
          primarySwatch: primarySwatchColor,
          fontFamily: GoogleFonts.lexend().fontFamily),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {'/': (context) => LoginPage()},
    );
  }
}
