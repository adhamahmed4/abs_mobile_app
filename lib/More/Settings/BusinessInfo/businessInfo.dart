import 'package:flutter/material.dart';

class BusinessInfoPage extends StatefulWidget {
  @override
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  TextEditingController _englishNameController =
      TextEditingController(text: "ABS Courier & Freight Systems");
  TextEditingController _arabicNameController =
      TextEditingController(text: "ايه بى اس كورير اند فريت سيستيمز");

  bool _englishNameEditable =
      false; // Track if the name field has been modified
  bool _arabicNameEditable = false; // Track if the name field has been modified

  String _selectedEnglishDropdownValue = 'Option 1';
  String _selectedArabicDropdownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Info'),
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
                      controller: _englishNameController,
                      readOnly: !_englishNameEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: "Business Name (English)",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_englishNameEditable) {
                                setState(() {
                                  _englishNameEditable = !_englishNameEditable;
                                });
                              } else {
                                setState(() {
                                  _englishNameEditable = !_englishNameEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_englishNameEditable
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
                      controller: _arabicNameController,
                      readOnly: !_arabicNameEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Business Name (Arabic)',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_arabicNameEditable) {
                                setState(() {
                                  _arabicNameEditable = !_arabicNameEditable;
                                });
                              } else {
                                setState(() {
                                  _arabicNameEditable = !_arabicNameEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_arabicNameEditable
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
