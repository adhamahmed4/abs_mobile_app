import 'package:abs_mobile_app/NavBar/More/Settings/BusinessLocations/maps.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class AddNewLocationPage extends StatefulWidget {
  final int locationID;

  AddNewLocationPage({required this.locationID});
  @override
  _AddNewLocationPageState createState() => _AddNewLocationPageState();
}

class _AddNewLocationPageState extends State<AddNewLocationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = true;

  List<Map<String, dynamic>> _addressTypes = [];
  List<Map<String, dynamic>> _cities = [];

  TextEditingController _locationNameController = TextEditingController();
  TextEditingController _streetNameController = TextEditingController();
  TextEditingController _buildingController = TextEditingController();
  TextEditingController _floorController = TextEditingController();
  TextEditingController _aptController = TextEditingController();
  TextEditingController _postalCodeController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  String? _selectedAddressType;
  double lat = 30.0444;
  double lng = 31.2357;
  String? _selectedCity;
  bool? _isActive;

  String __locationNameErrorText = '';
  String _streetNameErrorText = '';
  String _buildingErrorText = '';
  String _floorErrorText = '';
  String _aptErrorText = '';
  String _firstNameErrorText = '';
  String _lastNameErrorText = '';
  String _phoneNumberErrorText = '';
  String _emailErrorText = '';
  bool _isButtonEnabled = false;
  bool _dataExists = false;
  Locale? locale;

  void initState() {
    super.initState();
    getAddressTypes();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
    if (widget.locationID != 0) {
      getBusinessLocation();
    }
    getCities();
    _locationNameController.addListener(() {
      _validateLocationName(_locationNameController.text);
      _updateButtonEnabledStatus();
    });

    _streetNameController.addListener(() {
      _validateStreetName(_streetNameController.text);
      _updateButtonEnabledStatus();
    });

    _buildingController.addListener(() {
      _validateBuilding(_buildingController.text);
      _updateButtonEnabledStatus();
    });

    _floorController.addListener(() {
      _validateFloor(_floorController.text);
      _updateButtonEnabledStatus();
    });

    _aptController.addListener(() {
      _validateApt(_aptController.text);
      _updateButtonEnabledStatus();
    });

    _firstNameController.addListener(() {
      _validateFirstName(_firstNameController.text);
      _updateButtonEnabledStatus();
    });

    _lastNameController.addListener(() {
      _validateLastName(_lastNameController.text);
      _updateButtonEnabledStatus();
    });

    _phoneNumberController.addListener(() {
      _validatePhoneNumber(_phoneNumberController.text);
      _updateButtonEnabledStatus();
    });

    _emailController.addListener(() {
      _validateEmail(_emailController.text);
      _updateButtonEnabledStatus();
    });

    _updateButtonEnabledStatus();
  }

  void _validateLocationName(String locationName) {
    if (locationName.isEmpty) {
      if (mounted) {
        setState(() {
          __locationNameErrorText = 'Location Name is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          __locationNameErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateStreetName(String streetName) {
    if (streetName.isEmpty) {
      if (mounted) {
        setState(() {
          _streetNameErrorText = 'Street name is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _streetNameErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateBuilding(String building) {
    if (building.isEmpty) {
      if (mounted) {
        setState(() {
          _buildingErrorText = 'Building number is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _buildingErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateFloor(String floor) {
    if (floor.isEmpty) {
      if (mounted) {
        setState(() {
          _floorErrorText = 'Floor number is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _floorErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateApt(String apt) {
    if (apt.isEmpty) {
      if (mounted) {
        setState(() {
          _aptErrorText = 'Apt. number is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _aptErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateFirstName(String firstName) {
    if (firstName.isEmpty) {
      if (mounted) {
        setState(() {
          _firstNameErrorText = 'First name is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _firstNameErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateLastName(String lastName) {
    if (lastName.isEmpty) {
      if (mounted) {
        setState(() {
          _lastNameErrorText = 'Last name is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _lastNameErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validatePhoneNumber(String phoneNumber) {
    if (phoneNumber.isEmpty) {
      if (mounted) {
        setState(() {
          _phoneNumberErrorText = 'Phone number is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _phoneNumberErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _validateEmail(String email) {
    if (email.isEmpty) {
      if (mounted) {
        setState(() {
          _emailErrorText = 'Email is required';
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _emailErrorText = '';
        });
      }
    }
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    if (mounted) {
      setState(() {
        _isButtonEnabled = __locationNameErrorText.isEmpty &&
            _streetNameErrorText.isEmpty &&
            _buildingErrorText.isEmpty &&
            _floorErrorText.isEmpty &&
            _aptErrorText.isEmpty &&
            _firstNameErrorText.isEmpty &&
            _lastNameErrorText.isEmpty &&
            _phoneNumberErrorText.isEmpty &&
            _emailErrorText.isEmpty &&
            _locationNameController.text.isNotEmpty &&
            _streetNameController.text.isNotEmpty &&
            _buildingController.text.isNotEmpty &&
            _floorController.text.isNotEmpty &&
            _aptController.text.isNotEmpty &&
            _firstNameController.text.isNotEmpty &&
            _lastNameController.text.isNotEmpty &&
            _phoneNumberController.text.isNotEmpty &&
            _emailController.text.isNotEmpty;
      });
    }
  }

  Future<void> getBusinessLocation() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/locations-by-ID-to-edit/${widget.locationID}');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _selectedAddressType = jsonData[0]['locationTypeID'].toString();
            _locationNameController.text = jsonData[0]['locationName'];
            _selectedCity = jsonData[0]['cityID'].toString();
            _streetNameController.text = jsonData[0]['streetName'];
            _buildingController.text = jsonData[0]['buildingNumber'];
            _floorController.text = jsonData[0]['floorNumber'];
            _aptController.text = jsonData[0]['apartmentNumber'];
            _postalCodeController.text = jsonData[0]['postalCode'];
            _firstNameController.text = jsonData[0]['firstName'];
            _lastNameController.text = jsonData[0]['lastName'];
            _phoneNumberController.text = jsonData[0]['contactNumber'];
            _emailController.text = jsonData[0]['email'];
            _isActive = jsonData[0]['isActive'];
            _dataExists = true;
            isLoading = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  Future<void> getAddressTypes() async {
    final url = Uri.parse('${AppConfig.baseUrl}/address-types');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          locale.toString() == 'en'
              ? _addressTypes =
                  jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'enAddressType': item['enAddressType'],
                  };
                }).toList()
              : _addressTypes =
                  jsonData.map<Map<String, dynamic>>((dynamic item) {
                  return {
                    'ID': item['ID'],
                    'arAddressType': item['arAddressType'],
                  };
                }).toList();
          ;
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
          isLoading = false;
        });
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  Future<void> addBusinessLocation() async {
    final url = Uri.parse('${AppConfig.baseUrl}/business-locations');
    final requestBody = {
      'streetName': _streetNameController.text,
      'apartmentNumber': _aptController.text,
      'floorNumber': _floorController.text,
      'buildingNumber': _buildingController.text,
      'cityID': _selectedCity,
      'postalCode': _postalCodeController.text,
      'addressTypeID': _selectedAddressType,
      'longitude': lng,
      'latitude': lat,
      'locationName': _locationNameController.text,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'contactPersonTypeID': _selectedAddressType,
      'contactNumber': _phoneNumberController.text,
      'contactTypeID': _selectedAddressType,
      'numberTypeID': 1,
      'email': _emailController.text,
      'emailTypeID': _selectedAddressType
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final urlUpdate =
          Uri.parse('${AppConfig.baseUrl}/subAccounts-verification/verify/3');
      await http.put(urlUpdate, headers: AppConfig.headers);
      // Prefix does not exist, you can navigate here
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> activateLocation() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/locations/activate/${widget.locationID}');
    final requestBody = {
      'isActive': true,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.put(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deActivateLocation() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/locations/de-activate/${widget.locationID}');
    final requestBody = {
      'isActive': false,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.put(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> updateBusinessLocation() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/business-locations/${widget.locationID}');
    final requestBody = {
      'locationName': _locationNameController.text,
      'streetName': _streetNameController.text,
      'apartmentNumber': _aptController.text,
      'floorNumber': _floorController.text,
      'buildingNumber': _buildingController.text,
      'cityID': _selectedCity,
      'postalCode': _postalCodeController.text,
      'addressTypeID': _selectedAddressType,
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'contactNumber': _phoneNumberController.text,
      'email': _emailController.text,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.put(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final urlUpdate =
          Uri.parse('${AppConfig.baseUrl}/subAccounts-verification/verify/3');
      await http.put(urlUpdate, headers: AppConfig.headers);
      // Prefix does not exist, you can navigate here
      Navigator.pop(context);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Business Locations',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          if (!isLoading)
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Container(
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 0, 0, 32),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: FractionallySizedBox(
                                              widthFactor:
                                                  1.0, // This will make the width 100%
                                              child: Image.asset(
                                                'assets/images/map.png', // Path to your map image in assets
                                                fit: BoxFit
                                                    .fill, // Maintain aspect ratio
                                                height: 100,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 10,
                                          left: 0,
                                          right: 0,
                                          child: Container(
                                            color: Colors
                                                .transparent, // Make the container transparent
                                            child: Center(
                                              child: ElevatedButton.icon(
                                                onPressed: !_dataExists
                                                    ? () {
                                                        Navigator.push(
                                                          context,
                                                          PageRouteBuilder(
                                                            transitionDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        300),
                                                            pageBuilder:
                                                                (_, __, ___) =>
                                                                    MapsPage(
                                                              lat: lat,
                                                              lng: lng,
                                                            ),
                                                            transitionsBuilder: (_,
                                                                Animation<
                                                                        double>
                                                                    animation,
                                                                __,
                                                                Widget child) {
                                                              return SlideTransition(
                                                                position: Tween<
                                                                    Offset>(
                                                                  begin: Offset(
                                                                      1.0, 0.0),
                                                                  end: Offset
                                                                      .zero,
                                                                ).animate(
                                                                    animation),
                                                                child: child,
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      }
                                                    : null,
                                                icon: Icon(Icons.location_on),
                                                label: Text('Add Pin Location'),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFFFAB4A)),
                                          ),
                                          labelText: 'Address Type',
                                        ),
                                        child: SizedBox(
                                          height: 20,
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              value: _selectedAddressType,
                                              onChanged: (newValue) {
                                                if (mounted) {
                                                  setState(() {
                                                    _selectedAddressType =
                                                        newValue!;
                                                  });
                                                }
                                              },
                                              items: locale.toString() == 'en'
                                                  ? _addressTypes.map<
                                                      DropdownMenuItem<String>>(
                                                      (Map<String, dynamic>
                                                          value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value['ID']
                                                              .toString(),
                                                          child: Text(value[
                                                              'enAddressType']),
                                                        );
                                                      },
                                                    ).toList()
                                                  : _addressTypes.map<
                                                      DropdownMenuItem<String>>(
                                                      (Map<String, dynamic>
                                                          value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value['ID']
                                                              .toString(),
                                                          child: Text(value[
                                                              'arAddressType']),
                                                        );
                                                      },
                                                    ).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _locationNameController,
                                        decoration: InputDecoration(
                                          fillColor: const Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: "Location Name",
                                          errorText:
                                              __locationNameErrorText.isNotEmpty
                                                  ? __locationNameErrorText
                                                  : null,
                                        ),
                                        onChanged: (locationName) {
                                          _validateLocationName(locationName);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xFFFFAB4A)),
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
                                              items: _cities.map<
                                                  DropdownMenuItem<String>>(
                                                (Map<String, dynamic> value) {
                                                  return DropdownMenuItem<
                                                      String>(
                                                    value: value['City ID']
                                                        .toString(),
                                                    child: Text(
                                                        value['City Name']),
                                                  );
                                                },
                                              ).toList(),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _streetNameController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'Street name',
                                          errorText:
                                              _streetNameErrorText.isNotEmpty
                                                  ? _streetNameErrorText
                                                  : null,
                                        ),
                                        onChanged: (streetName) {
                                          _validateStreetName(streetName);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                8,
                                                16), // Adjust padding as needed
                                            child: TextField(
                                              controller: _buildingController,
                                              decoration: InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                filled: true,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFFFAB4A)),
                                                ),
                                                labelText: 'Building',
                                                errorText: _buildingErrorText
                                                        .isNotEmpty
                                                    ? _buildingErrorText
                                                    : null,
                                              ),
                                              onChanged: (building) {
                                                _validateBuilding(building);
                                                _updateButtonEnabledStatus();
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                8,
                                                16), // Adjust padding as needed
                                            child: TextField(
                                              controller: _floorController,
                                              decoration: InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                filled: true,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFFFAB4A)),
                                                ),
                                                labelText: 'Floor',
                                                errorText:
                                                    _floorErrorText.isNotEmpty
                                                        ? _floorErrorText
                                                        : null,
                                              ),
                                              onChanged: (floor) {
                                                _validateFloor(floor);
                                                _updateButtonEnabledStatus();
                                              },
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0,
                                                16), // Adjust padding as needed
                                            child: TextField(
                                              controller: _aptController,
                                              decoration: InputDecoration(
                                                fillColor: Color.fromARGB(
                                                    255, 250, 250, 250),
                                                filled: true,
                                                border:
                                                    const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Color(0xFFFFAB4A)),
                                                ),
                                                labelText: 'Apt.',
                                                errorText:
                                                    _aptErrorText.isNotEmpty
                                                        ? _aptErrorText
                                                        : null,
                                              ),
                                              onChanged: (apt) {
                                                _validateApt(apt);
                                                _updateButtonEnabledStatus();
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _postalCodeController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'Postal code',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                              child: Container(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: Text(
                                        'Contact Person',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _firstNameController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'First name',
                                          errorText:
                                              _firstNameErrorText.isNotEmpty
                                                  ? _firstNameErrorText
                                                  : null,
                                        ),
                                        onChanged: (firstName) {
                                          _validateFirstName(firstName);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _lastNameController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'Last name',
                                          errorText:
                                              _lastNameErrorText.isNotEmpty
                                                  ? _lastNameErrorText
                                                  : null,
                                        ),
                                        onChanged: (lastName) {
                                          _validateLastName(lastName);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _phoneNumberController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'Phone number',
                                          errorText:
                                              _phoneNumberErrorText.isNotEmpty
                                                  ? _phoneNumberErrorText
                                                  : null,
                                        ),
                                        onChanged: (phoneNumber) {
                                          _validatePhoneNumber(phoneNumber);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: TextField(
                                        controller: _emailController,
                                        decoration: InputDecoration(
                                          fillColor: Color.fromARGB(
                                              255, 250, 250, 250),
                                          filled: true,
                                          border: const OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Color(0xFFFFAB4A))),
                                          labelText: 'Email',
                                          errorText: _emailErrorText.isNotEmpty
                                              ? _emailErrorText
                                              : null,
                                        ),
                                        onChanged: (email) {
                                          _validateEmail(email);
                                          _updateButtonEnabledStatus();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Center(
                    child: !_dataExists
                        ? FractionallySizedBox(
                            widthFactor:
                                1.0, // This will make the button width 100%
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
                                        addBusinessLocation();
                                      }
                                    }
                                  : null,
                              child: const Padding(
                                padding: EdgeInsets.all(12.0),
                                child: Text('Add new location'),
                              ),
                            ),
                          )
                        : Column(
                            children: [
                              FractionallySizedBox(
                                widthFactor:
                                    1.0, // This will make the button width 100%
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isButtonEnabled
                                        ? Theme.of(context).primaryColor
                                        : const Color.fromARGB(249, 95, 95, 95),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        width: 1.4,
                                      ),
                                    ),
                                  ),
                                  onPressed: _isButtonEnabled
                                      ? () {
                                          if (_formKey.currentState!
                                              .validate()) {
                                            updateBusinessLocation();
                                          }
                                        }
                                      : null,
                                  child: const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: Text('Save'),
                                  ),
                                ),
                              ),
                              FractionallySizedBox(
                                widthFactor:
                                    1.0, // This will make the button width 100%
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(7),
                                      side: const BorderSide(
                                        color:
                                            Color.fromARGB(255, 138, 138, 138),
                                        width: 1.4,
                                      ),
                                    ),
                                  ),
                                  onPressed: _isActive!
                                      ? () {
                                          deActivateLocation();
                                        }
                                      : () {
                                          activateLocation();
                                        },
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      _isActive! ? 'De-activate' : 'Activate',
                                      style: const TextStyle(
                                        color: Colors.black,
                                      ),
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
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
