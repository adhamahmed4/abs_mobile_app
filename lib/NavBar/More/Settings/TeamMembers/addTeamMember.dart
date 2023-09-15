import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class AddTeamMemberPage extends StatefulWidget {
  @override
  _AddTeamMemberPageState createState() => _AddTeamMemberPageState();
}

class _AddTeamMemberPageState extends State<AddTeamMemberPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  List<Map<String, dynamic>> _subAccounts = [];
  List<Map<String, dynamic>> _roles = [];

  String? _selectedSubAccount;
  List<int>? _selectedRoles = [];
  bool isAdminChecked = false;
  bool _isButtonEnabled = false;
  bool _dataExists = false;

  @override
  void initState() {
    super.initState();
    getSubAccounts();
    getRoles();
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    if (mounted) {
      setState(() {
        _isButtonEnabled = _fullNameController.text.isNotEmpty &&
            _usernameController.text.isNotEmpty &&
            _passwordController.text.isNotEmpty &&
            _confirmPasswordController.text.isNotEmpty &&
            _selectedSubAccount != null &&
            _passwordController.text == _confirmPasswordController.text &&
            _selectedRoles!.isNotEmpty;
      });
    }
  }

  Future<void> getSubAccounts() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/sub-accounts-by-main-account-ID/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _subAccounts = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'ID': item['ID'],
              'Sub Account Name': item['Sub Account Name'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getRoles() async {
    final url = Uri.parse('${AppConfig.baseUrl}/roles');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _roles = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'Role ID': item['Role ID'],
              'Role': item['Role'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addTeamMember() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users');

    final requestBody = {
      'subAccountID': int.parse(_selectedSubAccount!),
      'username': _usernameController.text,
      'password': _passwordController.text,
      'displayedName': _fullNameController.text,
    };

    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);

      final requestBody = {
        'ROLES': _selectedRoles!.join(','),
      };

      final jsonBody = json.encode(requestBody);

      final url =
          Uri.parse('${AppConfig.baseUrl}/user-roles/${jsonData['ID']}');

      await http.post(url, headers: AppConfig.headers, body: jsonBody);

      Navigator.pop(context);
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: Text("Username already exists"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Add Team Member',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          if (!isLoading)
            Expanded(
              child: SingleChildScrollView(
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
                                    fillColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    filled: true,
                                    border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A)),
                                    ),
                                    labelText: 'Sub Account Name',
                                  ),
                                  child: SizedBox(
                                    height: 20,
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: _selectedSubAccount,
                                        onChanged: !_dataExists
                                            ? (newValue) {
                                                if (mounted) {
                                                  setState(() {
                                                    _selectedSubAccount =
                                                        newValue!;
                                                  });
                                                }
                                              }
                                            : null,
                                        items: _subAccounts
                                            .map<DropdownMenuItem<String>>(
                                          (Map<String, dynamic> value) {
                                            return DropdownMenuItem<String>(
                                              value: value['ID'].toString(),
                                              child: Text(
                                                  value['Sub Account Name']),
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
                                  controller: _fullNameController,
                                  readOnly: _dataExists,
                                  decoration: InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A))),
                                    labelText: "Full Name",
                                  ),
                                  onChanged: (fullName) {
                                    _updateButtonEnabledStatus();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: TextField(
                                  controller: _usernameController,
                                  readOnly: _dataExists,
                                  decoration: InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A))),
                                    labelText: 'Username',
                                  ),
                                  onChanged: (username) {
                                    _updateButtonEnabledStatus();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: TextField(
                                  controller: _passwordController,
                                  obscureText: !_passwordVisible,
                                  decoration: InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A))),
                                    labelText: 'Password',
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        if (mounted) {
                                          setState(() {
                                            _passwordVisible =
                                                !_passwordVisible;
                                          });
                                        }
                                      },
                                      child: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                      ),
                                    ),
                                  ),
                                  onChanged: (password) {
                                    _updateButtonEnabledStatus();
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                                child: TextField(
                                  controller: _confirmPasswordController,
                                  obscureText: !_confirmPasswordVisible,
                                  decoration: InputDecoration(
                                    fillColor:
                                        Color.fromARGB(255, 250, 250, 250),
                                    filled: true,
                                    border: const OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A))),
                                    labelText: 'Confirm Password',
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
                                  ),
                                  onChanged: (confirmPassword) {
                                    _updateButtonEnabledStatus();
                                  },
                                ),
                              ),
                              Text("Roles",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              Column(
                                children: _roles.map((role) {
                                  final roleID = role['Role ID'];
                                  final roleName = role['Role'];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 4),
                                    child: CheckboxListTile(
                                      title: Text(roleName),
                                      value: _selectedRoles!.contains(roleID),
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value!) {
                                              _selectedRoles!.add(roleID);
                                              if (roleName == "Admin") {
                                                isAdminChecked = true;
                                                _selectedRoles!.clear();
                                                _selectedRoles!.add(roleID);
                                              }
                                            } else {
                                              _selectedRoles!.remove(roleID);
                                              if (roleName == "Admin") {
                                                isAdminChecked = false;
                                              }
                                            }
                                            _updateButtonEnabledStatus();
                                          });
                                        }
                                      },
                                      enabled:
                                          isAdminChecked && roleName != "Admin"
                                              ? false
                                              : true,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _isButtonEnabled
                                ? Theme.of(context).primaryColor
                                : const Color.fromARGB(249, 95, 95, 95),
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
                                    addTeamMember();
                                  }
                                }
                              : null,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Add team member'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
