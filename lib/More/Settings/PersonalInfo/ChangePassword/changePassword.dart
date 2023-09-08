import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Configurations/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;

  void _updateButtonEnabledStatus() {
    setState(() {
      _isButtonEnabled = _oldPasswordController.text.isNotEmpty &&
          _newPasswordController.text.isNotEmpty &&
          _confirmNewPasswordController.text.isNotEmpty &&
          _newPasswordController.text == _confirmNewPasswordController.text;
    });
  }

  Future<void> changePassword() async {
    if (_oldPasswordController.text == _newPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Error'),
                content:
                    Text('New password cannot be the same as old password!'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  ),
                ],
              ));
      return;
    }
    final url = Uri.parse('${AppConfig.baseUrl}/change/password');
    final requestBody = {
      'password': _newPasswordController.text,
      'oldPassword': _oldPasswordController.text,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.put(url, headers: AppConfig.headers, body: jsonBody);
    final jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      if (jsonData == "Old password is incorrect!") {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Error'),
                  content: Text('Old password is incorrect!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('Success'),
                  content: Text('Password changed successfully'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                child: Container(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: TextField(
                          controller: _oldPasswordController,
                          obscureText: !_oldPasswordVisible,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: 'Old Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _oldPasswordVisible = !_oldPasswordVisible;
                                });
                              },
                              child: Icon(
                                _oldPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onChanged: (value) => _updateButtonEnabledStatus(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: TextField(
                          controller: _newPasswordController,
                          obscureText: !_newPasswordVisible,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: 'New Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _newPasswordVisible = !_newPasswordVisible;
                                });
                              },
                              child: Icon(
                                _newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onChanged: (value) => _updateButtonEnabledStatus(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: TextField(
                          controller: _confirmNewPasswordController,
                          obscureText: !_confirmNewPasswordVisible,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: 'Confirm Password',
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _confirmNewPasswordVisible =
                                      !_confirmNewPasswordVisible;
                                });
                              },
                              child: Icon(
                                _confirmNewPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onChanged: (value) => _updateButtonEnabledStatus(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              fixedSize: const Size(120, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                                side: const BorderSide(
                                  color: Color.fromARGB(255, 138, 138, 138),
                                  width: 1.4,
                                ),
                              ),
                            ),
                            onPressed: _isButtonEnabled
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      changePassword();
                                    }
                                  }
                                : null, // Disable the button if fields are not valid
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
