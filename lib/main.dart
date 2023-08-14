import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import 'Login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define a MaterialColor using the desired color value
    MaterialColor primarySwatchColor = MaterialColor(
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
    return MaterialApp(
      title: 'ABS Courier & Freight Systems',
      theme: ThemeData(
          primarySwatch: primarySwatchColor,
          fontFamily: GoogleFonts.lexend().fontFamily),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => MyLoginPage(),
        '/home': (context) =>
            const MyHomePage(title: 'ABS Courier & Freight Systems'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
