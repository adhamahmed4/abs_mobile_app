import 'package:abs_mobile_app/More/Settings/settings.dart';
import 'package:flutter/material.dart';

class BankTransferPage extends StatefulWidget {
  @override
  _BankTransferPageState createState() => _BankTransferPageState();
}

class _BankTransferPageState extends State<BankTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _accountOwnerNameController = TextEditingController();
  TextEditingController _accountNumberController = TextEditingController();
  TextEditingController _ibanController = TextEditingController();
  TextEditingController _swiftCodeController = TextEditingController();

  List<String> _bankNames = ['CIB', 'QNB', 'HSBC', 'ADIB', 'NBE'];
  late String _selectedBankName = _bankNames[0];

  String _accountOwnerNameErrorText = '';
  String _accountNumberErrorText = '';
  String _ibanErrorText = '';
  String _swiftCodeErrorText = '';
  bool _isButtonEnabled = false;

  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bank Transfer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'Bank',
                          ),
                          child: Container(
                            height: 20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedBankName,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedBankName = newValue!;
                                  });
                                },
                                items: _bankNames.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: TextField(
                          controller: _accountOwnerNameController,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: "Account Owner Name",
                            errorText: _accountOwnerNameErrorText.isNotEmpty
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
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
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
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
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
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
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
      ),
    );
  }
}
