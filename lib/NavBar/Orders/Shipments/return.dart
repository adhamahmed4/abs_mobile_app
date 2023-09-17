import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class ReturnPage extends StatefulWidget {
  @override
  _ReturnPageState createState() => _ReturnPageState();
}

class _ReturnPageState extends State<ReturnPage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _aptController = TextEditingController();
  TextEditingController _cashAmountController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  TextEditingController _specialInstructionsController =
      TextEditingController();

  List<Map<String, dynamic>> _cities = [];

  String? _selectedCity;

  int _currentIndex = 1;

  int _numberOfItems = 1;
  int _weight = 1;
  bool _refundCash = true;

  Future<void> getCities() async {
    final url = Uri.parse('${AppConfig.baseUrl}/cities/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _cities = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'City ID': item['City ID'],
              'City Name': item['City Name'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons
                                  .person, // Add the icon here, this is the icon of the notification
                              color:
                                  Colors.black, // Set the icon color as needed
                            ),
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Customer Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 4, 4),
                              child: TextField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'First name',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(4, 16, 16, 4),
                              child: TextField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Last name',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: TextField(
                          controller: _phoneNumberController,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Address',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'City',
                          ),
                          child: SizedBox(
                            height: 20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedCity,
                                onChanged: (newValue) {
                                  if (mounted) {
                                    setState(() {
                                      _selectedCity = newValue!;
                                    });
                                  }
                                },
                                items: _cities.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value['City ID'].toString(),
                                      child: Text(value['City Name']),
                                    );
                                  },
                                ).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: TextField(
                          controller: _streetNameController,
                          decoration: InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: 'Street name',
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  16, 16, 8, 16), // Adjust padding as needed
                              child: TextField(
                                controller: _buildingController,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Building',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 16, 8, 16), // Adjust padding as needed
                              child: TextField(
                                controller: _floorController,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Floor',
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  0, 16, 16, 16), // Adjust padding as needed
                              child: TextField(
                                controller: _aptController,
                                decoration: InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Apt.',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons
                                  .price_change, // Add the icon here, this is the icon of the notification
                              color:
                                  Colors.black, // Set the icon color as needed
                            ),
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Cash on delivery',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 0, 8),
                        child: Row(
                          children: [
                            const Text('Refund cash'),
                            Switch(
                              value: _refundCash,
                              onChanged: (value) {
                                setState(() {
                                  _refundCash = value;
                                });
                              },
                            ),
                            const Spacer(),
                            Visibility(
                              visible: _refundCash,
                              child: Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0, 0, 16, 8), // Adjust padding as needed
                                  child: SizedBox(
                                    width: double
                                        .infinity, // Makes the TextField take up 100% width
                                    child: TextField(
                                      controller: _cashAmountController,
                                      keyboardType: TextInputType
                                          .number, // Accepts numbers only
                                      decoration: InputDecoration(
                                        fillColor:
                                            Color.fromARGB(255, 250, 250, 250),
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color(0xFFFFAB4A)),
                                        ),
                                        labelText: 'COD',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Icon(
                              Icons
                                  .local_shipping, // Add the icon here, this is the icon of the notification
                              color:
                                  Colors.black, // Set the icon color as needed
                            ),
                            SizedBox(
                                width:
                                    8), // Add some spacing between the icon and text
                            Text(
                              'Return Shipment Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ToggleSwitch(
                            initialLabelIndex: _currentIndex - 1,
                            totalSwitches: 3,
                            cornerRadius: 10.0,
                            minHeight: 20.0,
                            minWidth: 100.0, // Set a minimum width for labels
                            labels: const ['Parcel', 'Document', 'Bulk'],
                            onToggle: (index) {
                              setState(() {
                                _currentIndex = index! + 1;
                              });
                              print('switched to: $_currentIndex');
                            },
                            borderColor: [
                              const Color.fromARGB(255, 227, 227, 227)
                            ],
                            activeBgColor: [Colors.white],
                            activeFgColor: Colors.black,
                            inactiveBgColor:
                                const Color.fromARGB(255, 227, 227, 227),
                            radiusStyle: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Text('Number of items'),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_numberOfItems > 1) {
                                          _numberOfItems--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_numberOfItems'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _numberOfItems++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Text('Weight'),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_weight > 1) {
                                          _weight--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_weight'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _weight++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _contentController,
                          maxLines: null, // Allow multiple lines of text
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Add a border around the text area
                            labelText: 'Content',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          controller: _specialInstructionsController,
                          maxLines: null, // Allow multiple lines of text
                          decoration: const InputDecoration(
                            border:
                                OutlineInputBorder(), // Add a border around the text area
                            labelText: 'Special Instructions',
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
