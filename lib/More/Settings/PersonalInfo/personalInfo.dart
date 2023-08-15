import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  TextEditingController _nameController =
      TextEditingController(text: "Adham Ahmed");
  TextEditingController _phoneController =
      TextEditingController(text: "+201001307530");
  TextEditingController _emailController =
      TextEditingController(text: "adhamahmeds2312@gmail.com");

  bool _phoneEditable = false; // Track the edit state for the phone field
  bool _emailEditable = false; // Track the edit state for the email field
  bool _nameEditable = false; // Track if the name field has been modified

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Info'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _nameController,
                      readOnly: !_nameEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Name',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_nameEditable) {
                                setState(() {
                                  _nameEditable = !_nameEditable;
                                });
                              } else {
                                setState(() {
                                  _nameEditable = !_nameEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_nameEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _phoneController,
                      readOnly: !_phoneEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Phone',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_phoneEditable) {
                                setState(() {
                                  _phoneEditable = !_phoneEditable;
                                });
                              } else {
                                setState(() {
                                  _phoneEditable = !_phoneEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_phoneEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _emailController,
                      readOnly: !_emailEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Email Address',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_emailEditable) {
                                setState(() {
                                  _emailEditable = !_emailEditable;
                                });
                              } else {
                                setState(() {
                                  _emailEditable = !_emailEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_emailEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
