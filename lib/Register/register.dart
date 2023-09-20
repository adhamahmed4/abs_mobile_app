// ignore_for_file: use_build_context_synchronously

import 'package:abs_mobile_app/Register/user_data.dart';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import './nextPage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:abs_mobile_app/Configurations/app_config.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isCheckboxChecked = false;
  bool _showPasswordValidation = false;
  String _fullNameErrorText = '';
  String _userNameErrorText = '';
  String _emailErrorText = '';
  String _confirmPasswordErrorText = '';
  String _phoneNumberErrorText = '';
  bool _passwordIsValid = false;
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(() {
      _validateFullName(_fullNameController.text);
      _updateButtonEnabledStatus();
    });

    _userNameController.addListener(() {
      _validateUserName(_userNameController.text);
      _updateButtonEnabledStatus();
    });

    _emailController.addListener(() {
      _validateEmail(_emailController.text);
      _updateButtonEnabledStatus();
    });

    _passwordController.addListener(() {
      _updateButtonEnabledStatus();
    });

    _confirmPasswordController.addListener(() {
      _validateConfirmPassword(_confirmPasswordController.text);
      _updateButtonEnabledStatus();
    });

    _phoneNumberController.addListener(() {
      if (_phoneNumberController.text.length > 11) {
        _phoneNumberController.text =
            _phoneNumberController.text.substring(0, 11);
      }

      _phoneNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _phoneNumberController.text.length),
      );

      _validatePhoneNumber(_phoneNumberController.text);
      _updateButtonEnabledStatus();
    });
  }

  void _validateFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length != 2 || nameParts.any((part) => part.isEmpty)) {
      if (mounted) {
        setState(() {
          _fullNameErrorText = 'Enter your first and last name';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _fullNameErrorText = '';
        });
      }
    }

    _updateButtonEnabledStatus();
  }

  void _validateUserName(String userName) {
    if (userName.isEmpty) {
      if (mounted) {
        setState(() {
          _userNameErrorText = 'Enter a user name';
        });
      }
    } else if (userName.length <= 7) {
      if (mounted) {
        setState(() {
          _userNameErrorText = 'User name should be at least 8 characters long';
        });
      }
    } else if (!RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(userName)) {
      if (mounted) {
        setState(() {
          _userNameErrorText =
              'User name should contain only letters, numbers, and spaces';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _userNameErrorText = '';
        });
      }
    }

    _updateButtonEnabledStatus();
  }

  void _validateEmail(String email) {
    if (!EmailValidator.validate(email)) {
      if (mounted) {
        setState(() {
          _emailErrorText = 'Enter a valid email';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _emailErrorText = '';
        });
      }
    }

    _updateButtonEnabledStatus();
  }

  Future<bool> _validateEmailExistence(String email) async {
    final requestBody = {"email": email};
    final jsonBody = json.encode(requestBody);
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/validate/email"),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    final data = json.decode(response.body);

    if (data["message"] == "Email already exists") {
      return false;
    }
    return true;
  }

  Future<bool> _validateUsernameExistence(String username) async {
    final requestBody = {"username": username};
    final jsonBody = json.encode(requestBody);
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/validate/username"),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    final data = json.decode(response.body);

    if (data["message"] == "Username already exists") {
      return false;
    }
    return true;
  }

  Future<bool> _validateMobileExistence(String mobile) async {
    final requestBody = {"mobile": mobile};

    final jsonBody = json.encode(requestBody);
    final response = await http.post(
      Uri.parse("${AppConfig.baseUrl}/validate/mobile"),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    final data = json.decode(response.body);

    if (data["message"] == "Phone number already exists") {
      return false;
    }
    return true;
  }

  void _validateConfirmPassword(String confirmPassword) {
    String password = _passwordController.text;

    if (confirmPassword != password) {
      if (mounted) {
        setState(() {
          _confirmPasswordErrorText = 'Passwords do not match';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _confirmPasswordErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      if (mounted) {
        setState(() {
          _phoneNumberErrorText = 'Phone number is required';
        });
      }
    } else if (phoneNumber.length != 11) {
      if (mounted) {
        setState(() {
          _phoneNumberErrorText = 'Phone number must be 11 digits';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _phoneNumberErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _showTermsAndConditionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 340,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFF2B2E83),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Terms and Conditions",
                    style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome to ABS! By using our app, you agree to comply with and be bound by the following terms and conditions. Please read them carefully before using the app.\n\n"
                        "Service Description\n\n"
                        "ABS provides users with the ability to request package delivery and track shipments. Our app is designed to make shipping and receiving packages convenient and efficient.\n\n"
                        "User Responsibilities\n\n"
                        "- You must provide accurate and up-to-date information when using the app.\n"
                        "- You must not use the app for any illegal or unauthorized purpose.\n"
                        "- You must not interfere with the app's functionality or security features.\n\n"
                        "Payment\n\n"
                        "- Payment for our services can be made through the methods provided in the app.\n"
                        "- Any charges associated with our services will be clearly displayed before you confirm your request.\n"
                        "Delivery and Shipping\n\n"
                        "- We strive to provide accurate delivery estimates, but actual delivery times may vary.\n"
                        "- Tracking features are available for most shipments.\n"
                        "- Packages must meet our size and weight restrictions and should not contain prohibited items.\n"
                        "Privacy and Data Handling\n\n"
                        "- We collect and use user data in accordance with our Privacy Policy.\n"
                        "- We use cookies and tracking technologies to enhance user experience and gather usage information.\n"
                        "Intellectual Property\n\n"
                        "- The content, trademarks, and copyrights in the app are owned by ABS.\n"
                        "- You may not use our intellectual property without our prior written consent.\n"
                        "Liability and Disclaimers\n\n"
                        "- We are not liable for any damages or losses arising from your use of the app.\n"
                        "- We do not guarantee the accuracy or availability of the information and services provided.\n"
                        "Termination\n\n"
                        "- We reserve the right to terminate or suspend user accounts for any reason.\n"
                        "- You may terminate your account at any time by following the app's instructions.\n"
                        "Governing Law\n\n"
                        "- These terms and conditions are governed by the laws of [Your Jurisdiction].\n"
                        "- Any disputes arising from these terms will be resolved in [Your Jurisdiction].\n"
                        "Changes to Terms\n\n"
                        "- We may update or modify these terms and conditions from time to time.\n"
                        "- Any changes will be communicated to users through the app.\n"
                        "Contact Information\n\n"
                        "If you have any questions or concerns about these terms and conditions, please contact us at [contact@email.com].",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 16),
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    child: const Text(
                      "Close",
                      style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _updateButtonEnabledStatus() async {
    if (mounted) {
      setState(() {
        _isButtonEnabled = _fullNameErrorText.isEmpty &&
            _userNameErrorText.isEmpty &&
            _emailErrorText.isEmpty &&
            _phoneNumberErrorText.isEmpty &&
            _passwordIsValid &&
            _confirmPasswordController.text == _passwordController.text;
      });
    }
  }

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F5),
      appBar: AppBar(
          title: const Text(
            'Create an account',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Start shipping with ABS',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 23,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _fullNameController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'Full Name',
                        errorText: _fullNameErrorText.isEmpty
                            ? null
                            : _fullNameErrorText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _userNameController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'User Name / Account Name',
                        errorText: _userNameErrorText.isEmpty
                            ? null
                            : _userNameErrorText,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'Email Address',
                        errorText:
                            _emailErrorText.isEmpty ? null : _emailErrorText,
                      ),
                      onChanged: (email) {
                        _validateEmail(email);
                        _updateButtonEnabledStatus();
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _phoneNumberController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'Phone Number',
                        errorText: _phoneNumberErrorText.isNotEmpty
                            ? _phoneNumberErrorText
                            : null,
                      ),
                      onChanged: (phoneNumber) {
                        _validatePhoneNumber(phoneNumber);
                        _updateButtonEnabledStatus();
                      },
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: !_passwordVisible,
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
                          filled: true,
                          fillColor: Colors.white,
                          hintText: "Password",
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
                          border: const OutlineInputBorder(
                            borderSide: BorderSide(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    if (_showPasswordValidation)
                      FlutterPwValidator(
                        key: validatorKey,
                        controller: _passwordController,
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
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_confirmPasswordVisible,
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (mounted) {
                              setState(() {
                                _confirmPasswordVisible =
                                    !_confirmPasswordVisible;
                              });
                            }
                          },
                          child: Icon(
                            _confirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        errorText: _confirmPasswordErrorText.isEmpty
                            ? null
                            : _confirmPasswordErrorText,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton(
                          onPressed: () {
                            _showTermsAndConditionsDialog(context);
                          },
                          child: const Text(
                            "Read Terms and Conditions",
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        CheckboxListTile(
                          title:
                              const Text("I agree to the terms and conditions"),
                          value: _isCheckboxChecked,
                          onChanged: (bool? newValue) {
                            if (newValue != null) {
                              if (mounted) {
                                setState(() {
                                  _isCheckboxChecked = newValue;
                                  _updateButtonEnabledStatus();
                                });
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                color: const Color.fromARGB(255, 138, 138, 138),
                                width: 1.4,
                              ),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          const SizedBox(width: 30),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                fixedSize: const Size(282, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(7),
                                  side: const BorderSide(
                                    color: Color.fromARGB(255, 138, 138, 138),
                                    width: 1.4,
                                  ),
                                ),
                              ),
                              onPressed: _isButtonEnabled && _isCheckboxChecked
                                  ? () async {
                                      if (_formKey.currentState!.validate()) {
                                        bool isEmailValid =
                                            await _validateEmailExistence(
                                                _emailController.text);
                                        bool isUsernameValid =
                                            await _validateUsernameExistence(
                                                _userNameController.text);
                                        bool isMobileValid =
                                            await _validateMobileExistence(
                                                _phoneNumberController.text);

                                        if (isEmailValid &&
                                            isUsernameValid &&
                                            isMobileValid) {
                                          UserData userData = UserData(
                                            fullName: _fullNameController.text,
                                            userName: _userNameController.text,
                                            email: _emailController.text,
                                            phoneNumber:
                                                _phoneNumberController.text,
                                            password: _passwordController.text,
                                          );
                                          Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                              transitionDuration:
                                                  const Duration(
                                                      milliseconds: 300),
                                              pageBuilder: (_, __, ___) =>
                                                  NextPage(
                                                userData: userData,
                                              ),
                                              transitionsBuilder: (_,
                                                  Animation<double> animation,
                                                  __,
                                                  Widget child) {
                                                return SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin:
                                                        const Offset(1.0, 0.0),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        } else {
                                          String errorMessage = '';
                                          if (!isEmailValid) {
                                            errorMessage =
                                                'Email is already taken.';
                                          }
                                          if (!isUsernameValid) {
                                            errorMessage =
                                                'Username is already taken.';
                                          }
                                          if (!isMobileValid) {
                                            errorMessage =
                                                'Mobile number is already taken.';
                                          }

                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content: Text(errorMessage),
                                              duration:
                                                  const Duration(seconds: 3),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  : null,
                              child: const Text(
                                'Next',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(249, 95, 95, 95),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
