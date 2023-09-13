import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class NearestBranchPage extends StatefulWidget {
  @override
  _NearestBranchPageState createState() => _NearestBranchPageState();
}

class _NearestBranchPageState extends State<NearestBranchPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  List<Map<String, dynamic>> _branches = [];
  String? _selectedBranch;

  bool _isButtonEnabled = false;

  bool _dataExists = false;

  @override
  void initState() {
    super.initState();
    getBranches();
    getNearestBranchDetails();
  }

  void _updateButtonEnabledStatus() {
    setState(() {
      _isButtonEnabled = _selectedBranch != null;
    });
  }

  Future<void> getNearestBranchDetails() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/nearest-branch-by-sub-account-ID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          _selectedBranch = jsonData[0]['Nearest Branch ID'].toString();
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

  Future<void> getBranches() async {
    final url = Uri.parse('${AppConfig.baseUrl}/branches/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        _branches = jsonData.map<Map<String, dynamic>>((dynamic item) {
          return {
            'Branch ID': item['Branch ID'],
            'Branch': item['Branch'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addNearestBranchDetails() async {
    final url = Uri.parse('${AppConfig.baseUrl}/add-payment-method/3');

    final requestBody = {
      'branchID': _selectedBranch,
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
        title: const Text('Nearest Branch'),
        centerTitle: true,
      ),
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
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              fillColor: Color.fromARGB(255, 250, 250, 250),
                              filled: true,
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A)),
                              ),
                              labelText: 'Branch',
                            ),
                            child: SizedBox(
                              height: 20,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: _selectedBranch,
                                  onChanged: !_dataExists
                                      ? (newValue) {
                                          setState(() {
                                            _selectedBranch = newValue!;
                                          });
                                          _updateButtonEnabledStatus();
                                        }
                                      : null,
                                  items:
                                      _branches.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                      return DropdownMenuItem<String>(
                                        value: value['Branch ID'].toString(),
                                        child: Text(value['Branch']),
                                      );
                                    },
                                  ).toList(),
                                ),
                              ),
                            ),
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
                                        addNearestBranchDetails();
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
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
