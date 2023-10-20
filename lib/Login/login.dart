// ignore_for_file: use_build_context_synchronously

import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:flutter/material.dart';
import 'package:abs_mobile_app/Register/register.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abs_mobile_app/Courier/Home/home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    final url_client = Uri.parse('${AppConfig.baseUrl}/signin-client');
    final requestBody_client = {
      "userCred": username,
      "password": password,
    };

    final jsonBody_client = json.encode(requestBody_client);

    final response_client = await http.post(
      url_client,
      headers: AppConfig.headers,
      body: jsonBody_client,
    );

    if (response_client.statusCode == 200) {
      final responseBody_client = json.decode(response_client.body);
      if (responseBody_client == 'User not found') {
        final url_employee = Uri.parse('${AppConfig.baseUrl}/signin-employee');

        final requestBody_employee = {
          "userCred": username,
          "password": password,
        };

        final jsonBody_employee = json.encode(requestBody_employee);

        final response_employee = await http.post(
          url_employee,
          headers: AppConfig.headers,
          body: jsonBody_employee,
        );

        if (response_employee.statusCode == 200) {
          final responseBody_employee = json.decode(response_employee.body);
          if (responseBody_employee == 'User not found') {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text(AppLocalizations.of(context)!.loginFailed),
                  content: Text(
                      AppLocalizations.of(context)!.invalidUsernameOrPassword),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                );
              },
            );
            return;
          }
          final accessToken = responseBody_employee["accessToken"].toString();
          await AppConfig.storeToken(accessToken);
          await AppConfig.initialize();

          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.loginFailed),
                content: Text(
                    AppLocalizations.of(context)!.invalidUsernameOrPassword),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              );
            },
          );
        }
      }
      if (responseBody_client != 'User not found' && response_client != 401) {
        final accessToken = responseBody_client["accessToken"].toString();
        await AppConfig.storeToken(accessToken);
        await AppConfig.initialize();

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const NavBar()),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.loginFailed),
            content:
                Text(AppLocalizations.of(context)!.invalidUsernameOrPassword),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
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
            title: Text(AppLocalizations.of(context)!.resetPasswordFailed),
            content:
                Text(AppLocalizations.of(context)!.pleaseEnterYourUsername),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(AppLocalizations.of(context)!.ok),
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
              AppLocalizations.of(context)!.resetPasswordLinkSentToYourEmail),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.resetPasswordFailed),
            content:
                Text(AppLocalizations.of(context)!.invalidUsernameOrPassword),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok)),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F5),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
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
                SizedBox(
                  height: 230,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                    child: Image.asset('assets/images/logo.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.welcomeBack,
                        style: const TextStyle(
                          color: Color(0xFF2B2E83),
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppLocalizations.of(context)!.loginToAccessYourAccount,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                          labelText: AppLocalizations.of(context)!.username,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
                        decoration: InputDecoration(
                          fillColor: const Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: const OutlineInputBorder(),
                          labelText: AppLocalizations.of(context)!.password,
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
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              resetPassword();
                            },
                            child: Text(
                              AppLocalizations.of(context)!.forgotPassword,
                              style: const TextStyle(color: Color(0xFF2B2E83)),
                            ),
                          ),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                              ),
                              onPressed: () {
                                _login();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  AppLocalizations.of(context)!.login,
                                  style: const TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: IntrinsicWidth(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      AppLocalizations.of(context)!
                                          .doNotHaveAnAccount,
                                      style: const TextStyle(
                                          color: Color(0xFF2B2E83))),
                                  const SizedBox(width: 4),
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
                                      AppLocalizations.of(context)!.create,
                                      style: const TextStyle(
                                        color: Color(0xFFFF9800),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward,
                                    color: Colors.orange,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
