// ignore_for_file: use_build_context_synchronously

import 'package:abs_mobile_app/main.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ExchangePage extends StatefulWidget {
  @override
  _ExchangePageState createState() => _ExchangePageState();
}

class _ExchangePageState extends State<ExchangePage> {
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
  final TextEditingController _deliveryOrderReferenceController =
      TextEditingController();
  final TextEditingController _deliveryContentController =
      TextEditingController();
  final TextEditingController _deliverySpecialInstructionsController =
      TextEditingController();
  final TextEditingController _returnContentController =
      TextEditingController();
  final TextEditingController _returnOrderReferencetController =
      TextEditingController();
  final TextEditingController _returnSpecialInstructionsController =
      TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  final TextEditingController _dateController = TextEditingController();

  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  List<Map<String, dynamic>> pickupLocations = [];
  List<Map<String, dynamic>> returnLocations = [];
  List<Map<String, dynamic>> vehicleTypes = [];

  String? _selectedPickupLocation;
  String? _selectedReturnLocation;
  String? _selectedVehicleType;

  List<Map<String, dynamic>> _cities = [];

  String? _selectedCity;

  int _deliveryPackageTypeID = 1;
  int _deliveryNumberOfItems = 1;
  int _deliveryWeight = 1;

  int _returnPackageTypeID = 1;
  int _returnNumberOfItems = 1;
  int _returnWeight = 1;

  int _collectionTypeID = 1;
  List<dynamic> _selectedServices = [];
  List<Map<String, dynamic>> _services = [];

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

  Future<void> getReturnLocations() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/pickup-return-locations-by-subAccountID');
    final body = {"locationType": "Return"};
    final jsonBody = json.encode(body);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          returnLocations = jsonData.map<Map<String, dynamic>>((dynamic item) {
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
      "serviceID": 3,

      //Pickup
      "returnLocationID": _selectedReturnLocation,
      "pickupTypeID": 1,
      "vehicleTypeID": _selectedVehicleType,
      "timeFrom": _selectedStartDate.toString(),
      "toTime": _selectedEndDate.toString(),
      "pickupNotes": _notesController.text,

      //Transaction
      "Ref": _deliveryOrderReferenceController.text,
      "specialInstructions": _deliverySpecialInstructionsController.text,
      "packageTypeID": _deliveryPackageTypeID,
      "noOfPcs": _deliveryNumberOfItems,
      "contents": _deliveryContentController.text,
      "weight": _deliveryWeight,
      "actualWeight": _deliveryWeight,
      "Cash": _cashAmountController.text,

      //In Case of Exchange
      "collectionTypeID": _collectionTypeID,
      "returnPackageTypeID": _returnPackageTypeID,
      "returnNoOfPcs": _returnNumberOfItems,
      "returnContents": _returnContentController.text,
      "returnWeight": _returnWeight,
      "returnSpecialInstructions": _returnSpecialInstructionsController.text,
      "returnRef": _returnOrderReferencetController.text,

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
              title: Text(AppLocalizations.of(context)!.accountIsNotVerified),
              content: Text(
                  AppLocalizations.of(context)!.pleaseVerifyYourAccountFirst),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
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
              title: Text(AppLocalizations.of(context)!.refAlreadyExists),
              content: Text(
                  AppLocalizations.of(context)!.pleaseEnterADifferentReference),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
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
    getReturnLocations();
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
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                        ),
                        labelText: AppLocalizations.of(context)!.subAccountName,
                      ),
                      child: SizedBox(
                        height: 25,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.person,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.customerDetails,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: locale.toString() == 'en'
                                  ? const EdgeInsets.fromLTRB(16, 16, 4, 4)
                                  : const EdgeInsets.fromLTRB(4, 16, 16, 4),
                              child: TextField(
                                controller: _firstNameController,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.firstName,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: locale.toString() == 'en'
                                  ? const EdgeInsets.fromLTRB(4, 16, 16, 4)
                                  : const EdgeInsets.fromLTRB(16, 16, 4, 4),
                              child: TextField(
                                controller: _lastNameController,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.lastName,
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
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.phoneNumber,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: Align(
                          alignment: locale.toString() == 'en'
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Text(
                            AppLocalizations.of(context)!.address,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: AppLocalizations.of(context)!.city,
                          ),
                          child: SizedBox(
                            height: 25,
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
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xFFFFAB4A))),
                            labelText: AppLocalizations.of(context)!.streetName,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: locale.toString() == 'en'
                                  ? const EdgeInsets.fromLTRB(16, 16, 8, 16)
                                  : const EdgeInsets.fromLTRB(8, 16, 16, 16),
                              child: TextField(
                                controller: _buildingController,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: AppLocalizations.of(context)!
                                      .buildingNumber,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: locale.toString() == 'en'
                                  ? const EdgeInsets.fromLTRB(0, 16, 8, 16)
                                  : const EdgeInsets.fromLTRB(8, 16, 0, 16),
                              child: TextField(
                                controller: _floorController,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.floorNumber,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: locale.toString() == 'en'
                                  ? const EdgeInsets.fromLTRB(0, 16, 16, 16)
                                  : const EdgeInsets.fromLTRB(16, 16, 0, 16),
                              child: TextField(
                                controller: _aptController,
                                decoration: InputDecoration(
                                  fillColor:
                                      const Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: const OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: AppLocalizations.of(context)!
                                      .apartmentNumber,
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
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.price_change,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.cashOnDelivery,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 8),
                          ],
                        ),
                      ),
                      Padding(
                          padding: locale.toString() == 'en'
                              ? const EdgeInsets.fromLTRB(16, 8, 0, 8)
                              : const EdgeInsets.fromLTRB(0, 8, 16, 8),
                          child: Row(
                            children: [
                              ToggleSwitch(
                                initialLabelIndex: _collectionTypeID - 1,
                                totalSwitches: 2,
                                cornerRadius: 10.0,
                                minHeight: 20.0,
                                minWidth: 90.0,
                                labels: [
                                  AppLocalizations.of(context)!.collect,
                                  AppLocalizations.of(context)!.refund
                                ],
                                onToggle: (index) {
                                  setState(() {
                                    _collectionTypeID = index! + 1;
                                  });
                                },
                                borderColor: const [
                                  Color.fromARGB(255, 227, 227, 227),
                                ],
                                activeBgColor: const [Colors.white],
                                activeFgColor: Colors.black,
                                inactiveBgColor:
                                    const Color.fromARGB(255, 227, 227, 227),
                                radiusStyle: true,
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 0, 16, 8),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: TextField(
                                      controller: _cashAmountController,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        fillColor: const Color.fromARGB(
                                            255, 250, 250, 250),
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A),
                                          ),
                                        ),
                                        labelText:
                                            AppLocalizations.of(context)!.cod,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
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
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!
                                  .deliveryShipmentDetails,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ToggleSwitch(
                            initialLabelIndex: _deliveryPackageTypeID - 1,
                            totalSwitches: 3,
                            cornerRadius: 10.0,
                            minHeight: 20.0,
                            minWidth: 100.0,
                            labels: [
                              AppLocalizations.of(context)!.parcel,
                              AppLocalizations.of(context)!.document,
                              AppLocalizations.of(context)!.bulk
                            ],
                            onToggle: (index) {
                              setState(() {
                                _deliveryPackageTypeID = index! + 1;
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
                            Text(AppLocalizations.of(context)!.numberOfItems),
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
                                        if (_deliveryNumberOfItems > 1) {
                                          _deliveryNumberOfItems--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_deliveryNumberOfItems'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _deliveryNumberOfItems++;
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
                            Text(AppLocalizations.of(context)!.weight),
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
                                        if (_deliveryWeight > 1) {
                                          _deliveryWeight--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_deliveryWeight'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _deliveryWeight++;
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
                          controller: _deliveryOrderReferenceController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.orderReference,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _deliveryContentController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.content,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _deliverySpecialInstructionsController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!
                                .specialInstructions,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText: AppLocalizations.of(context)!.services,
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
                            buttonText: Text(
                                AppLocalizations.of(context)!.selectServices),
                            chipDisplay: MultiSelectChipDisplay(),
                            searchHint:
                                AppLocalizations.of(context)!.searchServices,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.local_shipping,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!
                                  .returnShipmentDetails,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: ToggleSwitch(
                            initialLabelIndex: _returnPackageTypeID - 1,
                            totalSwitches: 3,
                            cornerRadius: 10.0,
                            minHeight: 20.0,
                            minWidth: 100.0,
                            labels: [
                              AppLocalizations.of(context)!.parcel,
                              AppLocalizations.of(context)!.document,
                              AppLocalizations.of(context)!.bulk
                            ],
                            onToggle: (index) {
                              setState(() {
                                _returnPackageTypeID = index! + 1;
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
                            Text(AppLocalizations.of(context)!.numberOfItems),
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
                                        if (_returnNumberOfItems > 1) {
                                          _returnNumberOfItems--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_returnNumberOfItems'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _returnNumberOfItems++;
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
                            Text(AppLocalizations.of(context)!.weight),
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
                                        if (_returnWeight > 1) {
                                          _returnWeight--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_returnWeight'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _returnWeight++;
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
                          controller: _returnOrderReferencetController,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText:
                                AppLocalizations.of(context)!.orderReference,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: TextField(
                          controller: _returnContentController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.content,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: TextField(
                          controller: _returnSpecialInstructionsController,
                          maxLines: 2,
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!
                                .specialInstructions,
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.pin_drop,
                              color: Colors.black,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!
                                  .pickupAndReturnDetails,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
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
                            labelText:
                                AppLocalizations.of(context)!.creationDate,
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
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.pickupLocation,
                          ),
                          child: SizedBox(
                            height: 25,
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
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.returnLocation,
                          ),
                          child: SizedBox(
                            height: 25,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: _selectedReturnLocation,
                                onChanged: (newValue) {
                                  if (mounted) {
                                    setState(() {
                                      _selectedReturnLocation = newValue!;
                                    });
                                  }
                                },
                                items: returnLocations
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
                          decoration: InputDecoration(
                            fillColor: const Color.fromARGB(255, 250, 250, 250),
                            filled: true,
                            border: const OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                            ),
                            labelText:
                                AppLocalizations.of(context)!.vehicleType,
                          ),
                          child: SizedBox(
                            height: 25,
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
                          decoration: InputDecoration(
                            border: const OutlineInputBorder(),
                            labelText: AppLocalizations.of(context)!.notes,
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
                  child: Text(AppLocalizations.of(context)!.createShipment),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomTooltip extends StatelessWidget {
  final String message;

  CustomTooltip({required this.message});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      icon: Icon(
        Icons.help_outline,
        color: Colors.black,
      ),
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry<int>>[
          PopupMenuItem<int>(
            value: 1,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ];
      },
      offset: Offset(0, -40),
    );
  }
}
