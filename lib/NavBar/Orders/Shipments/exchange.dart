import 'package:abs_mobile_app/NavBar/Orders/Shipments/addShipments.dart';
import 'package:abs_mobile_app/Track/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class ExchangePage extends StatefulWidget {
  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _aptController = TextEditingController();

  List<Map<String, dynamic>> _cities = [];

  String? _selectedCity;

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
                                readOnly: true,
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
                                readOnly: true,
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
                          readOnly: true,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
