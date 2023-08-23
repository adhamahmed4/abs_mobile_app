import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'NextPage.dart';
import 'dart:developer';

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

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _isCheckboxChecked = false;
  bool _hasScrolledToEnd = false;
  String _fullNameErrorText = '';
  String _userNameErrorText = '';
  String _emailErrorText = '';
  String _confirmPasswordErrorText = '';
  String _phoneNumberErrorText = '';
  bool _passwordIsValid = false;
  bool _isButtonEnabled = false;

  PhoneNumber _phoneNumber = PhoneNumber();

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
  }

  void _validateFullName(String fullName) {
    List<String> nameParts = fullName.split(' ');

    if (nameParts.length != 2 || nameParts.any((part) => part.isEmpty)) {
      setState(() {
        _fullNameErrorText = 'Enter your first and last name';
      });
    } else {
      setState(() {
        _fullNameErrorText = '';
      });
    }

    _updateButtonEnabledStatus(); // Call this here to update the button status
  }

  void _validateUserName(String userName) {
    if (userName.isEmpty) {
      setState(() {
        _userNameErrorText = 'Enter a user name';
      });
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(userName)) {
      setState(() {
        _userNameErrorText =
            'User name should contain only letters and numbers';
      });
    } else {
      setState(() {
        _userNameErrorText = '';
      });
    }

    _updateButtonEnabledStatus(); // Call this here to update the button status
  }

  void _validateEmail(String email) {
    if (!EmailValidator.validate(email)) {
      setState(() {
        _emailErrorText = 'Enter a valid email';
      });
    } else {
      setState(() {
        _emailErrorText = '';
      });
    }

    _updateButtonEnabledStatus(); // Call this here to update the button status
  }

  void _validateConfirmPassword(String confirmPassword) {
    String password = _passwordController.text;

    if (confirmPassword != password) {
      setState(() {
        _confirmPasswordErrorText = 'Passwords do not match';
      });
    } else {
      setState(() {
        _confirmPasswordErrorText = '';
      });
    }
  }

  void _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      setState(() {
        _phoneNumberErrorText = 'Phone number is required';
      });
    } else {
      setState(() {
        _phoneNumberErrorText = '';
      });
    }
  }

  void _updateCheckboxStatus(bool? newValue) {
    if (newValue != null) {
      setState(() {
        _isCheckboxChecked = newValue;
        _updateButtonEnabledStatus(); // Update the button status based on the new checkbox state
      });
    }
  }

  void _showTermsAndConditionsDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Terms and Conditions"),
          content: SingleChildScrollView(
            child: ListView(
              shrinkWrap: true,
              children: [
                Text("Here are the terms and conditions..."),
                // Add more text as needed
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _updateButtonEnabledStatus() {
    log("Updating button status...");
    log("_fullNameErrorText: $_fullNameErrorText");
    log("_userNameErrorText: $_userNameErrorText");
    log("_emailErrorText: $_emailErrorText");
    log("_confirmPasswordErrorText: $_confirmPasswordErrorText");
    log("_phoneNumberErrorText: $_phoneNumberErrorText");
    setState(() {
      _isButtonEnabled = _fullNameErrorText.isEmpty &&
          _userNameErrorText.isEmpty &&
          _emailErrorText.isEmpty &&
          _phoneNumberErrorText.isEmpty &&
          _passwordIsValid &&
          _confirmPasswordController.text == _passwordController.text;
    });
    log("_isButtonEnabled: $_isButtonEnabled");
  }

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF1F5),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(24, 60, 24, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Create an Account',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign up to access your account',
                      style: TextStyle(color: Colors.grey),
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
                        labelText: 'User Name',
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
                        _validateEmail(
                            email); // Call the email validation method
                        _updateButtonEnabledStatus(); // Update button status
                      },
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 75,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 250, 250, 250),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: const Color.fromARGB(255, 138, 138, 138),
                          width: 1.4,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: InternationalPhoneNumberInput(
                          onInputChanged: (PhoneNumber number) {
                            if (number.phoneNumber != null) {
                              _validatePhoneNumber(number.phoneNumber!);
                            }
                            setState(() {
                              _phoneNumber = number;
                            });
                          },
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          selectorTextStyle:
                              const TextStyle(color: Colors.black),
                          initialValue: _phoneNumber,
                        ),
                      ),
                    ),
                    if (_phoneNumberErrorText.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          _phoneNumberErrorText,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    if (_phoneNumberErrorText.isNotEmpty)
                      Text(
                        _phoneNumberErrorText,
                        style: const TextStyle(color: Colors.red),
                      ),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: TextField(
                          controller: _passwordController,
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: "Password",
                            suffixIcon: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                              child: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            border: const OutlineInputBorder(
                                borderSide: BorderSide()),
                          )),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
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
                        setState(() {
                          _passwordIsValid = true;
                        });
                        _updateButtonEnabledStatus();
                      },
                      onFail: () {
                        setState(() {
                          _passwordIsValid = false;
                        });
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
                            setState(() {
                              _confirmPasswordVisible =
                                  !_confirmPasswordVisible;
                            });
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
                            _showTermsAndConditionsDialog(); // Implement this method to show the terms and conditions dialog
                          },
                          child: Text(
                            "Read Terms and Conditions",
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        CheckboxListTile(
                          title: Text("I agree to the terms and conditions"),
                          value: _hasScrolledToEnd,
                          onChanged: (newValue) {
                            setState(() {
                              if (_hasScrolledToEnd) {
                                _hasScrolledToEnd = false;
                              } else {
                                _hasScrolledToEnd = true;
                                _updateButtonEnabledStatus(); // Update the button status based on the new checkbox state
                              }
                            });
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
                                // Implement Back functionality
                                Navigator.pop(
                                    context); // This will navigate back to the previous screen
                              },
                              icon: const Icon(Icons.arrow_back),
                            ),
                          ),
                          const SizedBox(
                              width:
                                  30), // Add spacing between the back button and "Next" button
                          ElevatedButton(
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
                                ? () {
                                    if (_formKey.currentState!.validate()) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => NextPage()),
                                      );
                                    }
                                  }
                                : null, // Disable the button if fields are not valid
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(249, 95, 95, 95),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
