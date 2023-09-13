import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class BankTransferPage extends StatefulWidget {
  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  TextEditingController _accountOwnerNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ibanController = TextEditingController();
  TextEditingController _swiftCodeController = TextEditingController();

  List<Map<String, dynamic>> _banks = [];
  String? _selectedBank;
  String _accountOwnerNameErrorText = '';
  String _accountNumberErrorText = '';
  String _ibanErrorText = '';
  String _swiftCodeErrorText = '';
  bool _isButtonEnabled = false;
  bool _dataExists = false;

  void initState() {
    super.initState();
    getBanks();
    getBankDetails();
    _accountOwnerNameController.addListener(() {
      _validateAccountOwnerName(_accountOwnerNameController.text);
      _updateButtonEnabledStatus();
    });

    _accountNumberController.addListener(() {
      _validateAccountNumber(_accountNumberController.text);
      _updateButtonEnabledStatus();
    });

    _ibanController.addListener(() {
      _validateIBAN(_ibanController.text);
      _updateButtonEnabledStatus();
    });

    _swiftCodeController.addListener(() {
      _validateSwiftCode(_swiftCodeController.text);
      _updateButtonEnabledStatus();
    });

    _updateButtonEnabledStatus();
  }

  void _validateAccountOwnerName(String accountOwnerName) {
    if (accountOwnerName.isEmpty) {
      setState(() {
        _accountOwnerNameErrorText = 'Account Owner Name is required';
      });
    } else {
      setState(() {
        _accountOwnerNameErrorText = '';
      });
    }
    _updateButtonEnabledStatus();
  }

  void _validateAccountNumber(String accountNumber) {
    if (accountNumber.isEmpty) {
      setState(() {
        _accountNumberErrorText = 'Account Number is required';
      });
    } else {
      setState(() {
        _accountNumberErrorText = '';
      });
    }
    _updateButtonEnabledStatus();
  }

  void _validateIBAN(String iban) {
    if (iban.isEmpty) {
      setState(() {
        _ibanErrorText = 'IBAN is required';
      });
    } else {
      setState(() {
        _ibanErrorText = '';
      });
    }
    _updateButtonEnabledStatus();
  }

  void _validateSwiftCode(String swiftCode) {
    if (swiftCode.isEmpty) {
      setState(() {
        _swiftCodeErrorText = 'Swift Code is required';
      });
    } else {
      setState(() {
        _swiftCodeErrorText = '';
      });
    }
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    setState(() {
      _isButtonEnabled = _accountOwnerNameErrorText.isEmpty &&
          _accountNumberErrorText.isEmpty &&
          _ibanErrorText.isEmpty &&
          _swiftCodeErrorText.isEmpty &&
          _accountOwnerNameController.text.isNotEmpty &&
          _accountNumberController.text.isNotEmpty &&
          _ibanController.text.isNotEmpty &&
          _swiftCodeController.text.isNotEmpty;
    });
  }

  Future<void> getBankDetails() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/bank-details-by-sub-account-ID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          _selectedBank = jsonData[0]['Bank ID'].toString();
          _accountOwnerNameController.text = jsonData[0]['Account Holder Name'];
          _accountNumberController.text = jsonData[0]['Account Number'];
          _ibanController.text = jsonData[0]['IBAN'];
          _swiftCodeController.text = jsonData[0]['Swift Code'];
          _dataExists = true;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          _dataExists = false;
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getBanks() async {
    final url = Uri.parse('${AppConfig.baseUrl}/banks/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        _banks = jsonData.map<Map<String, dynamic>>((dynamic item) {
          return {
            'ID': item['ID'],
            'enBankName': item['enBankName'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addBankDetails() async {
    final url = Uri.parse('${AppConfig.baseUrl}/add-payment-method/4');

    final requestBody = {
      'accountHolderName': _accountOwnerNameController.text,
      'accountNumber': _accountNumberController.text,
      'bankNameID': int.parse(_selectedBank!),
      'IBAN': _ibanController.text,
      'swiftCode': _swiftCodeController.text,
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
        title: const Text('Bank Transfer'),
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
                      child: Container(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Bank',
                                ),
                                child: SizedBox(
                                  height: 20,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedBank,
                                      onChanged: !_dataExists
                                          ? (newValue) {
                                              setState(() {
                                                _selectedBank = newValue!;
                                              });
                                            }
                                          : null,
                                      items:
                                          _banks.map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> value) {
                                          return DropdownMenuItem<String>(
                                            value: value['ID'].toString(),
                                            child: Text(value['enBankName']),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _accountOwnerNameController,
                                readOnly: _dataExists,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Account Owner Name",
                                  errorText:
                                      _accountOwnerNameErrorText.isNotEmpty
                                          ? _accountOwnerNameErrorText
                                          : null,
                                ),
                                onChanged: (accountOwnerName) {
                                  _validateAccountOwnerName(accountOwnerName);
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _accountNumberController,
                                readOnly: _dataExists,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Account Number',
                                  errorText: _accountNumberErrorText.isNotEmpty
                                      ? _accountNumberErrorText
                                      : null,
                                ),
                                onChanged: (accountNumber) {
                                  _validateAccountNumber(accountNumber);
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _ibanController,
                                readOnly: _dataExists,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText:
                                      'IBAN (International Bank Account Number)',
                                  errorText: _ibanErrorText.isNotEmpty
                                      ? _ibanErrorText
                                      : null,
                                ),
                                onChanged: (iban) {
                                  _validateIBAN(iban);
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _swiftCodeController,
                                readOnly: _dataExists,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Swift Code',
                                  errorText: _swiftCodeErrorText.isNotEmpty
                                      ? _swiftCodeErrorText
                                      : null,
                                ),
                                onChanged: (swiftCode) {
                                  _validateSwiftCode(swiftCode);
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
                                          addBankDetails();
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
