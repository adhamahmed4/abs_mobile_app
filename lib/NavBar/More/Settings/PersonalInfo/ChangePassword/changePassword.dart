import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Configurations/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();
  bool _isButtonEnabled = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController _oldPasswordController = TextEditingController();
  TextEditingController _newPasswordController = TextEditingController();
  TextEditingController _confirmNewPasswordController = TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmNewPasswordVisible = false;
  bool _showPasswordValidation = false;
  bool _passwordIsValid = false;

  void _updateButtonEnabledStatus() {
    if (mounted) {
      setState(() {
        _isButtonEnabled = _oldPasswordController.text.isNotEmpty &&
            _newPasswordController.text.isNotEmpty &&
            _confirmNewPasswordController.text.isNotEmpty &&
            _newPasswordController.text == _confirmNewPasswordController.text &&
            _passwordIsValid;
      });
    }
  }

  Future<void> changePassword() async {
    if (_oldPasswordController.text == _newPasswordController.text) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.error),
                content: Text(AppLocalizations.of(context)!
                    .newPasswordCannotBeTheSameAsOldPassword),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.ok),
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
                  title: Text(AppLocalizations.of(context)!.error),
                  content: Text(
                      AppLocalizations.of(context)!.oldPasswordIsIncorrect),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
                    ),
                  ],
                ));
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(AppLocalizations.of(context)!.success),
                  content: Text(AppLocalizations.of(context)!
                      .passwordChangedSuccessfully),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: Text(AppLocalizations.of(context)!.ok),
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
          title: Text(
            AppLocalizations.of(context)!.changePassword,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
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
                            labelText:
                                AppLocalizations.of(context)!.oldPassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _oldPasswordVisible = !_oldPasswordVisible;
                                  });
                                }
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
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                if (!_passwordIsValid) {
                                  _showPasswordValidation = true;
                                } else {
                                  _showPasswordValidation = false;
                                }
                              });
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText:
                                AppLocalizations.of(context)!.newPassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _newPasswordVisible = !_newPasswordVisible;
                                  });
                                }
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
                      // const SizedBox(height: 5),
                      if (_showPasswordValidation)
                        FlutterPwValidator(
                          key: validatorKey,
                          controller: _newPasswordController,
                          minLength: 8,
                          uppercaseCharCount: 1,
                          lowercaseCharCount: 1,
                          numericCharCount: 1,
                          width: 400,
                          height: 130,
                          onSuccess: () {
                            if (mounted) {
                              setState(() {
                                _passwordIsValid = true;
                                _showPasswordValidation = false;
                              });
                            }
                            _updateButtonEnabledStatus();
                          },
                          onFail: () {
                            if (mounted) {
                              setState(() {
                                _passwordIsValid = false;
                                _showPasswordValidation = true;
                              });
                            }
                            _updateButtonEnabledStatus();
                          },
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
                            labelText:
                                AppLocalizations.of(context)!.confirmPassword,
                            suffixIcon: GestureDetector(
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _confirmNewPasswordVisible =
                                        !_confirmNewPasswordVisible;
                                  });
                                }
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
                            child: Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text(AppLocalizations.of(context)!.submit),
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
