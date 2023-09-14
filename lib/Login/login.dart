import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/Home/navBar.dart';
import 'package:abs_mobile_app/Register/nextPage.dart';
import 'package:flutter/material.dart';
import 'package:abs_mobile_app/Register/register.dart';
import 'package:abs_mobile_app/Home/Home.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Import the http package

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> _login() async {
    final url = Uri.parse('${AppConfig.baseUrl}/signin-client');
    final requestBody = {
      "userCred": _usernameController.text,
      "password": _passwordController.text
    };

// Convert the map to a JSON string
    final jsonBody = json.encode(requestBody);

// Set the headers for the request
    final headers = {
      'Content-Type': 'application/json',
    };
    final response = await http.post(
      url,
      headers: headers,
      body: jsonBody,
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final accessToken = responseBody["accessToken"];
      await AppConfig.storeToken(accessToken);
      await AppConfig.initialize();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NavBar()),
      );
    } else {
      // Failed login
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Login Failed'),
            content: Text('Invalid username or password.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> resetPassword() async {
    if (_usernameController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Password Failed'),
            content: Text('Please enter your username.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final url = Uri.parse('${AppConfig.baseUrl}/reset-password');
    final requestBody = {
      "userCred": _usernameController.text,
    };
    final jsonBody = json.encode(requestBody);
    final response = await http.post(
      url,
      headers: AppConfig.headers,
      body: jsonBody,
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset password email sent.',
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Reset Password Failed'),
            content: Text('Invalid username.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF1F5),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/login_bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 230,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: TextStyle(
                          color: Color(0xFF2B2E83),
                          fontSize: 30,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Login to access your account.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                          labelText: 'Username',
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                          suffixIcon: GestureDetector(
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              }
                            },
                            child: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              resetPassword();
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xFF2B2E83)),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            onPressed: () {
                              _login();
                            },
                            child: Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Container(
                          height: 40,
                          width: 280,
                          decoration: BoxDecoration(
                            color: Colors
                                .white, // Set the background color to white
                            border: Border.all(
                              color: const Color.fromARGB(
                                  255, 255, 255, 255), // Set the border color
                            ),
                            borderRadius: BorderRadius.circular(
                                6), // Set the border radius
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?",
                                  style: TextStyle(
                                    color: Color(0xFF2B2E83),
                                  )),
                              SizedBox(width: 4),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            RegistrationPage()),
                                  );
                                },
                                child: Text(
                                  'Create',
                                  style: TextStyle(
                                    color: Color(0xFFFF9800),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.orange,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 100), // Adding some space at the bottom
              ],
            ),
          ),
        ],
      ),
    );
  }
}
