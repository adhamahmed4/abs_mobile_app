// Import the necessary packages
// ignore_for_file: use_build_context_synchronously

import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class UndeliveredShipments extends StatefulWidget {
  const UndeliveredShipments({Key? key}) : super(key: key);

  @override
  _UndeliveredShipmentsState createState() => _UndeliveredShipmentsState();
}

class _UndeliveredShipmentsState extends State<UndeliveredShipments> {
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      if (mounted) {
        setState(() {
          _searchController.text = barcodeScanRes;
        });
      }
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;
  }

  String? _selectedRecipientType;
  List<Map<String, dynamic>> _recipientTypes = [];
  ValueNotifier<String?> _selectedRecipientTypeNotifier =
      ValueNotifier<String?>(null);
  final TextEditingController _recipientNameController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  Future<void> getRecipientTypes() async {
    final url = Uri.parse('${AppConfig.baseUrl}/recipient-types');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        locale.toString() == 'en'
            ? setState(() {
                _recipientTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'Recipient Type': item['Recipient Type'],
                  };
                }).toList();
              })
            : setState(() {
                _recipientTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'رقم الصفة': item['رقم الصفة'],
                    'صفة المستلم': item['صفة المستلم'],
                  };
                }).toList();
              });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getReasons() async {
    final url = Uri.parse('${AppConfig.baseUrl}/reasons');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        locale.toString() == 'en'
            ? setState(() {
                _recipientTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'Reason': item['Reason'],
                  };
                }).toList();
              })
            : setState(() {
                _recipientTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'رقم السبب': item['رقم السبب'],
                    'السبب': item['السبب'],
                  };
                }).toList();
              });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Locale? locale;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  // Function to show the AlertDialog
  void _showDetailsDialog(
      String name, String date, String address, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Order Details'),
                      _buildDetailItem('AWB', 'dfjksj'),
                      _buildDetailItem('Status', 'delivered'),
                      _buildDetailItem('Payment', '57 EGP'),
                    ],
                  ),
                  Image.asset(
                    'assets/images/courier2.png', // Replace with the actual path to your image
                    width: 150, // Adjust the width as needed
                    height: 150, // Adjust the height as needed
                  ),
                ],
              ),
              _buildSectionHeader('User Details'),
              _buildDetailItem('Name', name),
              _buildDetailItem('Address', address),
              _buildDetailItem('Phone Number', phoneNumber),
              const SizedBox(height: 15),
              _buildSectionHeader('Notes'),
              const Text(
                'This is a note.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                ),
                child: const Text('Back',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> showDeliveredDialog() async {
    await getRecipientTypes();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 250, 250, 250),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                  ),
                  labelText: AppLocalizations.of(context)!.recipientType,
                ),
                child: SizedBox(
                  height: 25,
                  child: DropdownButtonHideUnderline(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _selectedRecipientTypeNotifier,
                      builder: (context, selectedValue, child) {
                        return DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (newValue) {
                            _selectedRecipientTypeNotifier.value = newValue;
                          },
                          items: locale.toString() == 'en'
                              ? _recipientTypes.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['ID'].toString(),
                                    child: Text(value['Recipient Type']),
                                  );
                                }).toList()
                              : _recipientTypes.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['رقم الصفة'].toString(),
                                    child: Text(value['صفة المستلم']),
                                  );
                                }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: _recipientNameController,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                    filled: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                    labelText: AppLocalizations.of(context)!.recipientName,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> showUndeliveredDialog() async {
    await getReasons();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              InputDecorator(
                decoration: InputDecoration(
                  fillColor: const Color.fromARGB(255, 250, 250, 250),
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                  ),
                  labelText: AppLocalizations.of(context)!.reason,
                ),
                child: SizedBox(
                  height: 25,
                  child: DropdownButtonHideUnderline(
                    child: ValueListenableBuilder<String?>(
                      valueListenable: _selectedRecipientTypeNotifier,
                      builder: (context, selectedValue, child) {
                        return DropdownButton<String>(
                          value: selectedValue,
                          onChanged: (newValue) {
                            _selectedRecipientTypeNotifier.value = newValue;
                          },
                          items: locale.toString() == 'en'
                              ? _recipientTypes.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['ID'].toString(),
                                    child: Text(value['Reason']),
                                  );
                                }).toList()
                              : _recipientTypes.map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                  return DropdownMenuItem<String>(
                                    value: value['رقم السبب'].toString(),
                                    child: Text(value['السبب']),
                                  );
                                }).toList(),
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                child: TextField(
                  controller: _recipientNameController,
                  decoration: InputDecoration(
                    fillColor: const Color.fromARGB(255, 250, 250, 250),
                    filled: true,
                    border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                    labelText: AppLocalizations.of(context)!.notes,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Save',
                      style: TextStyle(fontSize: 18, color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Text(
      '  $label: $value',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }

  Widget _CourierCard(
      String name, String date, String address, String phoneNumber) {
    return Card(
      elevation: 4, // Adjust the card's elevation (shadow)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABS2018531',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Jan 20 2023 5:30 PM',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                child: SizedBox(
                  width: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () {
                      // Call the function to show the AlertDialog
                      _showDetailsDialog(name, date, address, phoneNumber);
                    },
                    child: const Text(
                      'Details',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Row(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/courier2.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(date),
                        Text(address),
                        Text(phoneNumber),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchByawb,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (awb) {
                    // searchByAWB(awb);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // searchByAWB(_searchController.text);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.crop_free,
                  color: Colors.black,
                ),
                onPressed: () {
                  scanBarcodeNormal();
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    // searchResults.clear();
                  });
                },
              ),
            ],
          ),

          // Existing content starts here
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Adham Ahmed',
                    'Jan 20 2023 5:30 PM',
                    '65 Misr Helwan Agricultural Road, Maadi, Cairo, Egypt',
                    '01001307530',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Jane Smith',
                    'September 21, 2023',
                    '456 Elm Street, Town, Country',
                    '+1 (987) 654-3210',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Alice Johnson',
                    'September 22, 2023',
                    '789 Oak Street, Village, Country',
                    '+1 (555) 123-4567',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Bob Wilson',
                    'September 23, 2023',
                    '101 Pine Street, Suburb, Country',
                    '+1 (777) 888-9999',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Eve Adams',
                    'September 24, 2023',
                    '202 Cedar Street, County, Country',
                    '+1 (333) 444-5555',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Michael Brown',
                    'September 25, 2023',
                    '303 Maple Street, State, Country',
                    '+1 (222) 111-0000',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Sophia Taylor',
                    'September 26, 2023',
                    '404 Birch Street, Province, Country',
                    '+1 (999) 000-1111',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
