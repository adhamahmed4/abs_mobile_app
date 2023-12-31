import 'package:flutter/material.dart';
import 'dart:developer';
import '../../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletDetailsPage extends StatefulWidget {
  @override
  _WalletDetailsPageState createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends State<WalletDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  TextEditingController _mobileNumberController = TextEditingController();
  TextEditingController _walletNumberController = TextEditingController();

  String _mobileNumberErrorText = '';
  String _walletNumberErrorText = '';
  bool _isButtonEnabled = false;
  bool _dataExists = false;

  @override
  void initState() {
    super.initState();
    getWalletDetails();

    _walletNumberController.addListener(() {
      _validateWalletNumber(_walletNumberController.text);
      _updateButtonEnabledStatus();
    });

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

  void _validateWalletNumber(String walletNumber) {
    if (walletNumber.isEmpty) {
      if (mounted) {
        setState(() {
          _walletNumberErrorText =
              AppLocalizations.of(context)!.enterAWalletNumber;
        });
      }
    } else if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(walletNumber)) {
      if (mounted) {
        setState(() {
          _walletNumberErrorText = AppLocalizations.of(context)!
              .walletNumberShouldContainOnlyLettersAndNumbers;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _walletNumberErrorText = '';
        });
      }
    }

    _updateButtonEnabledStatus(); // Call this here to update the button status
  }

  void _validateMobileNumber(String mobileNumber) {
    if (mobileNumber.isEmpty) {
      if (mounted) {
        setState(() {
          _mobileNumberErrorText =
              AppLocalizations.of(context)!.mobileNumberIsRequired;
        });
      }
    } else if (mobileNumber.length != 11) {
      if (mounted) {
        setState(() {
          _mobileNumberErrorText =
              AppLocalizations.of(context)!.mobileNumberMustBeDigits;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _mobileNumberErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    if (mounted) {
      setState(() {
        _isButtonEnabled = _walletNumberErrorText.isEmpty &&
            _mobileNumberErrorText.isEmpty &&
            _walletNumberController.text.isNotEmpty;
      });
    }
  }

  Future<void> getWalletDetails() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/wallet-details-by-sub-account-ID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _walletNumberController.text = jsonData[0]['Wallet Number'];
            _mobileNumberController.text = jsonData[0]['Mobile Number'];
            _dataExists = true;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            _dataExists = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  Future<void> addWalletDetails() async {
    final url = Uri.parse('${AppConfig.baseUrl}/add-payment-method/2');

    final requestBody = {
      'walletNumber': _walletNumberController.text,
      'mobileWalletNumber': _mobileNumberController.text,
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
          title: Text(
            AppLocalizations.of(context)!.wallet,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          if (!isLoading)
            Form(
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
                            controller: _walletNumberController,
                            readOnly: _dataExists,
                            decoration: InputDecoration(
                              fillColor:
                                  const Color.fromARGB(255, 250, 250, 250),
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A))),
                              labelText:
                                  AppLocalizations.of(context)!.walletNumber,
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
                            readOnly: _dataExists,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              fillColor: Color.fromARGB(255, 250, 250, 250),
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A))),
                              labelText:
                                  AppLocalizations.of(context)!.mobileNumber,
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
                                        addWalletDetails();
                                      }
                                    }
                                  : null, // Disable the button if fields are not valid
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child:
                                    Text(AppLocalizations.of(context)!.submit),
                              ),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
