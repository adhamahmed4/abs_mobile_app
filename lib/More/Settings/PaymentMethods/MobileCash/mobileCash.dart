import 'package:abs_mobile_app/More/Settings/settings.dart';
import 'package:flutter/material.dart';

class MobileCashPage extends StatefulWidget {
  @override
  _MobileCashPageState createState() => _MobileCashPageState();
}

class _MobileCashPageState extends State<MobileCashPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _mobileNumberController =
      TextEditingController(text: "+20");

  String _mobileNumberErrorText = '';
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();

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
      _isButtonEnabled = _mobileNumberErrorText.isEmpty &&
          _mobileNumberController.text != "+20";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mobile Cash'),
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
