import 'package:abs_mobile_app/More/Settings/settings.dart';
import 'package:flutter/material.dart';

import 'dart:developer';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberController =
      TextEditingController(text: "+20");
  TextEditingController _walletNumberController = TextEditingController();

  String _mobileNumberErrorText = '';
  String _walletNumberErrorText = '';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

    _walletNumberController.addListener(() {
      _validateWalletNumber(_walletNumberController.text);
      _updateButtonEnabledStatus();
    });

    _mobileNumberController.addListener(() {
      // Ensure the text starts with "+20"
      if (!_mobileNumberController.text.startsWith("+20")) {
        _mobileNumberController.text = "+20";
      }

      // Ensure the total length is 13 characters (including the prefix)
      if (_mobileNumberController.text.length > 13) {
        _mobileNumberController.text =
            _mobileNumberController.text.substring(0, 13);
      }

      // Move the cursor to the end
      _mobileNumberController.selection = TextSelection.fromPosition(
        TextPosition(offset: _mobileNumberController.text.length),
      );

      // Call the phone number validation method
      _validateMobileNumber(_mobileNumberController.text);
      _updateButtonEnabledStatus();
    });
  }

  void _validateWalletNumber(String walletNumber) {
    log(walletNumber);
    if (walletNumber.isEmpty) {
      setState(() {
        _walletNumberErrorText = 'Enter a wallet number';
      });
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(walletNumber)) {
      setState(() {
        _walletNumberErrorText =
            'Wallet number should contain only letters and numbers';
      });
    } else {
      setState(() {
        _walletNumberErrorText = '';
      });
    }

    _updateButtonEnabledStatus(); // Call this here to update the button status
  }

  void _validateMobileNumber(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      setState(() {
        _mobileNumberErrorText = 'Mobile number is required';
      });
    } else if (mobileNumber.length != 13) {
      setState(() {
        _mobileNumberErrorText = 'Mobile number must be 10 digits';
      });
    } else if (!mobileNumber.startsWith('+20')) {
      setState(() {
        _mobileNumberErrorText = 'Mobile number must start with +20';
      });
    } else {
      setState(() {
        _mobileNumberErrorText = '';
      });
    }
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    setState(() {
      _isButtonEnabled = _walletNumberErrorText.isEmpty &&
          _mobileNumberErrorText.isEmpty &&
          _walletNumberController.text.isNotEmpty &&
          _mobileNumberController.text != "+20";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: TextField(
                        controller: _walletNumberController,
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                          labelText: "Wallet Number",
                          errorText: _walletNumberErrorText.isNotEmpty
                              ? _walletNumberErrorText
                              : null,
                        ),
                        onChanged: (walletNumber) {
                          _validateWalletNumber(walletNumber);
                          _updateButtonEnabledStatus();
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: TextField(
                        controller: _mobileNumberController,
                        keyboardType: TextInputType.phone,
                        maxLength: 13, // +20 + 10 digits
                        decoration: InputDecoration(
                          fillColor: Color.fromARGB(255, 250, 250, 250),
                          filled: true,
                          border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                          labelText: "Mobile Number",
                          errorText: _mobileNumberErrorText.isNotEmpty
                              ? _mobileNumberErrorText
                              : null,
                        ),
                        onChanged: (mobileNumber) {
                          _validateMobileNumber(mobileNumber);
                          _updateButtonEnabledStatus();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isButtonEnabled
                        ? Theme.of(context).primaryColor
                        : Color.fromARGB(249, 95, 95, 95),
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
                            Navigator.pop(context); // Go back once
                            Navigator.pop(context); // Go back again
                          }
                        }
                      : null, // Disable the button if fields are not valid
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text('Submit'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}