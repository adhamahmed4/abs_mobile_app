import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  String _fullNameErrorText = '';
  String _userNameErrorText = '';
  String _emailErrorText = '';
  String _passwordErrorText = '';
  String _confirmPasswordErrorText = '';
  String _phoneNumberErrorText = '';

  PhoneNumber _phoneNumber = PhoneNumber();

  @override
  void initState() {
    super.initState();
    _fullNameController.addListener(() {
      _validateFullName(_fullNameController.text);
    });

    _userNameController.addListener(() {
      _validateUserName(_userNameController.text);
    });

    _emailController.addListener(() {
      _validateEmail(_emailController.text);
    });

    // _passwordController.addListener(() {
    //   _validatePassword(_passwordController.text);
    // });

    _confirmPasswordController.addListener(() {
      _validateConfirmPassword(_confirmPasswordController.text);
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
  }

  // void _validatePassword(String password) {
  //   bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
  //   bool hasLowercase = password.contains(RegExp(r'[a-z]'));
  //   bool hasDigit = password.contains(RegExp(r'[0-9]'));

  //   String errorText = '';

  //   if (password.length < 8) {
  //     errorText += 'At least 8 characters\n';
  //   }
  //   if (!hasUppercase) {
  //     errorText += 'At least one uppercase letter\n';
  //   }
  //   if (!hasLowercase) {
  //     errorText += 'At least one lowercase letter\n';
  //   }
  //   if (!hasDigit) {
  //     errorText += 'At least one number\n';
  //   }

  //   setState(() {
  //     _passwordErrorText = errorText;
  //   });
  // }

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

  final GlobalKey<FlutterPwValidatorState> validatorKey =
      GlobalKey<FlutterPwValidatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF1F5),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(24, 60, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Create an Account',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign up to access your account',
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Full Name',
                      errorText: _fullNameErrorText.isEmpty
                          ? null
                          : _fullNameErrorText,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                      errorText: _userNameErrorText.isEmpty
                          ? null
                          : _userNameErrorText,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      fillColor: Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Email Address',
                      errorText:
                          _emailErrorText.isEmpty ? null : _emailErrorText,
                    ),
                  ),
                  SizedBox(height: 12),
                  Container(
                    height: 65,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 250, 250, 250),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: Color.fromARGB(255, 138, 138, 138),
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
                        selectorConfig: SelectorConfig(
                          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                        ),
                        selectorTextStyle: TextStyle(color: Colors.black),
                        initialValue: _phoneNumber,
                      ),
                    ),
                  ),
                  if (_phoneNumberErrorText.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        _phoneNumberErrorText,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  if (_phoneNumberErrorText.isNotEmpty)
                    Text(
                      _phoneNumberErrorText,
                      style: TextStyle(color: Colors.red),
                    ),
                  SizedBox(height: 12),
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
                          border: OutlineInputBorder(borderSide: BorderSide()),
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
                      print("MATCHED");
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Password is matched")));
                    },
                    onFail: () {
                      print("NOT MATCHED");
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
                      border: OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: () {
                          setState(() {
                            _confirmPasswordVisible = !_confirmPasswordVisible;
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
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(120, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: () {
                        // Implement Sign up functionality
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
