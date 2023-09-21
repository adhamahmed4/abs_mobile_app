// ignore_for_file: use_build_context_synchronously

import 'package:abs_mobile_app/main.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class DeliveryPage extends StatefulWidget {
  @override
  _DeliveryPageState createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  List<Map<String, dynamic>> _subAccounts = [];
  String? _selectedSubAccount;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _buildingController = TextEditingController();
  final TextEditingController _floorController = TextEditingController();
  final TextEditingController _aptController = TextEditingController();
  final TextEditingController _cashAmountController = TextEditingController();
  final TextEditingController _orderReferenceController =
      TextEditingController();

  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;

  List<Map<String, dynamic>> _cities = [];

  String? _selectedCity;

  int _packageTypeID = 1;

  int _numberOfItems = 1;
  int _weight = 1;
  bool _collectCash = true;
  List<dynamic> _selectedServices = [];
  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> pickupLocations = [];
  List<Map<String, dynamic>> vehicleTypes = [];

  String? _selectedPickupLocation;
  String? _selectedVehicleType;
  Locale? locale;

  Future<void> getSubAccounts() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/sub-accounts-by-main-account-ID/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        locale.toString() == 'en'
            ? setState(() {
                _subAccounts =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'Sub Account Name': item['Sub Account Name'],
                  };
                }).toList();
              })
            : setState(() {
                _subAccounts =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'اسم الحساب الفرعي': item['اسم الحساب الفرعي'],
                  };
                }).toList();
              });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

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

  Future<void> getServices() async {
    final url = Uri.parse('${AppConfig.baseUrl}/service-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _services = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'Service Type ID': item['Service Type ID'],
              'Service Type': item['Service Type'] +
                  ' (' +
                  item['Price'].toString() +
                  ' EGP)',
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getPickupLocations() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/pickup-return-locations-by-subAccountID');
    final body = {"locationType": "Pickup"};
    final jsonBody = json.encode(body);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          pickupLocations = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {'ID': item["ID"], 'Location Name': item['Location Name']};
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getVehicleTypes() async {
    final url = Uri.parse('${AppConfig.baseUrl}/vehicle-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        locale.toString() == 'en'
            ? setState(() {
                vehicleTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'Vehicle Type ID': item['Vehicle Type ID'],
                    'Vehicle Type': item['Vehicle Type'],
                  };
                }).toList();
              })
            : setState(() {
                vehicleTypes =
                    jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'رقم نوع السيارة': item['رقم نوع السيارة'],
                    'نوع السيارة': item['نوع السيارة'],
                  };
                }).toList();
              });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime? initialStartDate = _selectedStartDate ?? DateTime.now();
    DateTime? initialEndDate = _selectedEndDate ?? DateTime.now();

    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: initialStartDate,
        end: initialEndDate,
      ),
    );

    if (selectedRange != null) {
      if (mounted) {
        setState(() {
          _selectedStartDate = selectedRange.start;
          _selectedEndDate = selectedRange.end;

          String startDateText = _selectedStartDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedStartDate!)
              : '';

          String endDateText = _selectedEndDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedEndDate!)
              : '';

          if (startDateText.isNotEmpty && endDateText.isNotEmpty) {
            _dateController.text = "$startDateText - $endDateText";
          } else if (startDateText.isNotEmpty) {
            _dateController.text = startDateText;
          } else if (endDateText.isNotEmpty) {
            _dateController.text = endDateText;
          }
        });
      }
    }
  }

  Future<void> getSubAccountServiceTypeIDs(String subAccountID) async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/services-by-subAccountID/$subAccountID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _selectedServices = jsonData["serviceTypeIDs"];
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> createShipment() async {
    final url = Uri.parse('${AppConfig.baseUrl}/create-single-shipment');

    final List<String> selectedServices =
        _selectedServices.map((value) => value.toString()).toList();

    final requestBody = {
      "subAccountID": _selectedSubAccount,
      "serviceID": 1,

      //Pickup
      "pickupLocationID": _selectedPickupLocation,
      "pickupTypeID": 1,
      "vehicleTypeID": _selectedVehicleType,
      "timeFrom": _selectedStartDate.toString(),
      "toTime": _selectedEndDate.toString(),
      "pickupNotes": _notesController.text,

      //Transaction
      "Ref": _orderReferenceController.text,
      "specialInstructions": _specialInstructionsController.text,
      "packageTypeID": _packageTypeID,
      "noOfPcs": _numberOfItems,
      "contents": _contentController.text,
      "weight": _weight,
      "actualWeight": _weight,
      "Cash": _collectCash ? _cashAmountController.text : 0,

      //ContactPerson - ContactNumber - Address
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "contactNumber": _phoneNumberController.text,
      "numberTypeID": 1,
      "cityID": _selectedCity,
      "streetName": _streetNameController.text,
      "buildingNumber": _buildingController.text,
      "floorNumber": _floorController.text,
      "apartmentNumber": _aptController.text,
      "longitude": 0,
      "latitude": 0,

      "serviceTypeIDs": selectedServices,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (responseData == 'Account is not verified') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Account is not verified'),
              content: const Text('Please verify your account first'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      } else if (responseData == 'Ref already exists') {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ref already exists'),
              content: const Text('Please enter a different reference'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
        return;
      }

      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getCities();
    getServices();
    getPickupLocations();
    getVehicleTypes();
    getSubAccounts();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
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
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                        ),
                        labelText: 'Sub Account Name',
                      ),
                      child: SizedBox(
                        height: 20,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedSubAccount,
                            onChanged: (newValue) {
                              if (mounted) {
                                setState(() {
                                  _selectedSubAccount = newValue!;
                                });
                                getSubAccountServiceTypeIDs(newValue!);
                              }
                            },
                            items: locale.toString() == 'en'
                                ? _subAccounts.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                      return DropdownMenuItem<String>(
                                        value: value['ID'].toString(),
                                        child: Text(value['Sub Account Name']),
                                      );
                                    },
                                  ).toList()
                                : _subAccounts.map<DropdownMenuItem<String>>(
                                    (Map<String, dynamic> value) {
                                      return DropdownMenuItem<String>(
                                        value: value['ID'].toString(),
                                        child: Text(value['اسم الحساب الفرعي']),
                                      );
                                    },
                                  ).toList(),
                          ),
                        ),
                      ),
                    ),
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
                              Icons.person,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
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
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
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
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
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
                              padding: const EdgeInsets.fromLTRB(16, 16, 8, 16),
                              child: TextField(
                                controller: _buildingController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
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
                              padding: const EdgeInsets.fromLTRB(0, 16, 8, 16),
                              child: TextField(
                                controller: _floorController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
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
                              padding: const EdgeInsets.fromLTRB(0, 16, 16, 16),
                              child: TextField(
                                controller: _aptController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
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
                              Icons.price_change,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
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
                            const Text('Collect cash'),
                            Switch(
                              value: _collectCash,
                              onChanged: (value) {
                                setState(() {
                                  _collectCash = value;
                                });
                              },
                            ),
                            Visibility(
                              visible: _collectCash,
                              child: Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 16, 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                      controller: _cashAmountController,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        fillColor:
                                            Color.fromARGB(255, 250, 250, 250),
                                        filled: true,
                                        border: OutlineInputBorder(
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
                              Icons.local_shipping,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Delivery Shipment Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ToggleSwitch(
                            initialLabelIndex: _packageTypeID - 1,
                            totalSwitches: 3,
                            cornerRadius: 10.0,
                            minHeight: 20.0,
                            minWidth: 100.0,
                            labels: const ['Parcel', 'Document', 'Bulk'],
                            onToggle: (index) {
                              setState(() {
                                _packageTypeID = index! + 1;
                              });
                            },
                            borderColor: const [
                              Color.fromARGB(255, 227, 227, 227)
                            ],
                            activeBgColor: const [Colors.white],
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
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: TextField(
                          controller: _orderReferenceController,
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: 'Order Reference',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _contentController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Content',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _specialInstructionsController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Special Instructions',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'Services',
                          ),
                          child: MultiSelectDialogField(
                            initialValue: _selectedServices,
                            items: _services
                                .map((e) => MultiSelectItem(
                                    e['Service Type ID'],
                                    e['Service Type'].toString()))
                                .toList(),
                            listType: MultiSelectListType.CHIP,
                            onConfirm: (selectedItems) {
                              if (mounted) {
                                setState(() {
                                  _selectedServices =
                                      List<int>.from(selectedItems);
                                });
                              }
                            },
                            buttonText: const Text('Select Services'),
                            chipDisplay: MultiSelectChipDisplay(),
                            searchHint: 'Search Services',
                          ),
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
                              Icons.pin_drop,
                              color: Colors.black,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Pickup Details',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: TextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () {
                            _selectDateRange(context);
                          },
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'Creation Date',
                            suffixIcon: const Icon(Icons.calendar_view_day),
                            hintText: _selectedStartDate == null ||
                                    _selectedEndDate == null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                                : '${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)} - ${DateFormat('yyyy-MM-dd').format(_selectedEndDate!)}',
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
                            labelText: 'Pickup location',
                          ),
                          child: SizedBox(
                            height: 20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedPickupLocation,
                                onChanged: (newValue) {
                                  if (mounted) {
                                    setState(() {
                                      _selectedPickupLocation = newValue!;
                                    });
                                  }
                                },
                                items: pickupLocations
                                    .map<DropdownMenuItem<String>>(
                                  (Map<String, dynamic> value) {
                                    return DropdownMenuItem<String>(
                                      value: value['ID'].toString(),
                                      child: Text(value['Location Name']),
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
                        child: InputDecorator(
                          decoration: const InputDecoration(
                            fillColor: Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: 'Vehicle type',
                          ),
                          child: SizedBox(
                            height: 20,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedVehicleType,
                                onChanged: (newValue) {
                                  if (mounted) {
                                    setState(() {
                                      _selectedVehicleType = newValue!;
                                    });
                                  }
                                },
                                items: locale.toString() == 'en'
                                    ? vehicleTypes
                                        .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> value) {
                                          return DropdownMenuItem<String>(
                                            value: value['Vehicle Type ID']
                                                .toString(),
                                            child: Text(value['Vehicle Type']),
                                          );
                                        },
                                      ).toList()
                                    : vehicleTypes
                                        .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> value) {
                                          return DropdownMenuItem<String>(
                                            value: value['رقم نوع السيارة']
                                                .toString(),
                                            child: Text(value['نوع السيارة']),
                                          );
                                        },
                                      ).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          controller: _notesController,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Notes',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    createShipment();
                  },
                  child: const Text('Create Shipment'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
