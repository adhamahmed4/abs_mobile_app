import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class MobileCashPage extends StatefulWidget {
  @override
  _MobileCashPageState createState() => _MobileCashPageState();
}

class _MobileCashPageState extends State<MobileCashPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  TextEditingController _mobileNumberController = TextEditingController();

  String _mobileNumberErrorText = '';
  bool _isButtonEnabled = false;
  bool _dataExists = false;

  @override
  void initState() {
    super.initState();
    getMobileCashDetails();

    _mobileNumberController.addListener(() {
      // Ensure the total length is 13 characters (including the prefix)
      if (_mobileNumberController.text.length > 11) {
        _mobileNumberController.text =
            _mobileNumberController.text.substring(0, 11);
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
    } else if (mobileNumber.length != 11) {
      setState(() {
        _mobileNumberErrorText = 'Mobile number must be 11 digits';
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
      _isButtonEnabled = _mobileNumberErrorText.isEmpty;
    });
  }

  Future<void> getMobileCashDetails() async {
    final url = Uri.parse('${AppConfig.baseUrl}/mobile-cash-by-sub-account-ID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          _mobileNumberController.text = jsonData[0]['mobileNumber'];
          _dataExists = true;
          isLoading = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addMobileCashDetails() async {
    final url = Uri.parse('${AppConfig.baseUrl}/add-payment-method/1');

    final requestBody = {
      'mobileCashNumber': _mobileNumberController.text,
    };

    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final urlUpdate =
          Uri.parse('${AppConfig.baseUrl}/subAccounts-verification/verify/4');
      await http.put(urlUpdate, headers: AppConfig.headers);
      // Prefix does not exist, you can navigate here
      Navigator.pop(context); // Go back once
      Navigator.pop(context); // Go back again
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Cash'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: TextField(
                              controller: _mobileNumberController,
                              readOnly: _dataExists,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                fillColor:
                                    const Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A))),
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
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: !_dataExists
                            ? ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _isButtonEnabled
                                      ? Theme.of(context).primaryColor
                                      : const Color.fromARGB(249, 95, 95, 95),
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
                                          addMobileCashDetails();
                                        }
                                      }
                                    : null, // Disable the button if fields are not valid
                                child: const Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Text('Submit'),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
