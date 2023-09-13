import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Configurations/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class BusinessInfoPage extends StatefulWidget {
  const BusinessInfoPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  final Dio _dio = Dio();

  bool isLoading = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _englishNameController = TextEditingController();
  final TextEditingController _arabicNameController = TextEditingController();
  final TextEditingController _salesChannelNameController =
      TextEditingController();
  final TextEditingController _storeURLController = TextEditingController();
  final TextEditingController _prefixController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _buildingNumberController =
      TextEditingController();
  final TextEditingController _floorNumberController = TextEditingController();
  final TextEditingController _apartmentNumberController =
      TextEditingController();

  String? _nationalID;
  String? _commercialRegister;

  bool _dataExists = false;
  bool _isButtonEnabled = false;

  String? _selectedSalesChannel;
  String? _selectedProduct;
  String? _selectedCity;
  List<dynamic> _selectedServices = [];

  List<Map<String, dynamic>> _salesChannels = [];
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _cities = [];
  List<Map<String, dynamic>> _services = [];

  String? idImageName;
  String? idImagePath;
  String? commercialRegisterImageName;
  String? commercialRegisterImagePath;

  @override
  void initState() {
    super.initState();
    getSalesChannels();
    getProducts();
    getCities();
    getServices();
    getCurrentBusinessInfo();
  }

  Future<void> getCurrentBusinessInfo() async {
    final url = Uri.parse('${AppConfig.baseUrl}/business-info');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      if (jsonData.isNotEmpty) {
        setState(() {
          _englishNameController.text = jsonData[0]['English Business Name'];
          _arabicNameController.text = jsonData[0]['Arabic Business Name'];
          _selectedSalesChannel = jsonData[0]['Sales Channel Type'].toString();
          _salesChannelNameController.text = jsonData[0]['Sales Channel Name'];
          _storeURLController.text = jsonData[0]['Sales Channel URL'];
          _selectedProduct = jsonData[0]['Product Type'].toString();
          _prefixController.text = jsonData[0]['Prefix'] ?? '';
          _selectedCity = jsonData[0]['City ID'].toString();
          _streetNameController.text = jsonData[0]['Street Name'];
          _buildingNumberController.text = jsonData[0]['Building Number'];
          _floorNumberController.text = jsonData[0]['Floor Number'];
          _apartmentNumberController.text = jsonData[0]['Apartment Number'];
          _selectedServices = jsonData[0]['Services ID']
              .split(',')
              .map((str) => int.parse(str))
              .toList();
          isLoading = false;
          _dataExists = true;
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

  Future<void> getSalesChannels() async {
    final url = Uri.parse('${AppConfig.baseUrl}/salesChannel-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        _salesChannels = jsonData.map<Map<String, dynamic>>((dynamic item) {
          return {
            'Sales Channeel Type ID': item['Sales Channeel Type ID'],
            'Sales Channeel Type': item['Sales Channeel Type'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getProducts() async {
    final url = Uri.parse('${AppConfig.baseUrl}/products');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        _products = jsonData.map<Map<String, dynamic>>((dynamic item) {
          return {
            'ID': item['ID'],
            'enProduct': item['enProduct'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getCities() async {
    final url = Uri.parse('${AppConfig.baseUrl}/cities/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

      setState(() {
        _cities = jsonData.map<Map<String, dynamic>>((dynamic item) {
          return {
            'City ID': item['City ID'],
            'City Name': item['City Name'],
          };
        }).toList();
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getServices() async {
    final url = Uri.parse('${AppConfig.baseUrl}/service-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);

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
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _pickIDImage() async {
    final imagePicker = ImagePicker();

    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    idImageName = pickedImage.path.split('/').last;
    idImagePath = pickedImage.path;
    final prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        idImagePath!,
        filename: idImageName, // Replace with the desired file name
      ),
    });

    Response response = await _dio.post(
      "${AppConfig.baseUrl}/images/single",
      data: formData,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString("accessToken")}",
        },
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _nationalID = response.data['url'];
      });
      _updateButtonEnabledStatus();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("National ID Uploaded Successfully"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> _pickCommercialRegisterImage() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    commercialRegisterImageName = pickedImage.path.split('/').last;
    commercialRegisterImagePath = pickedImage.path;
    final prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        commercialRegisterImagePath!,
        filename:
            commercialRegisterImageName, // Replace with the desired file name
      ),
    });

    Response response = await _dio.post(
      "${AppConfig.baseUrl}/images/single",
      data: formData,
      options: Options(
        headers: {
          "authorization": "Bearer ${prefs.getString("accessToken")}",
        },
      ),
    );

    if (response.statusCode == 200) {
      setState(() {
        _commercialRegister = response.data['url'];
      });
      _updateButtonEnabledStatus();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Success"),
              content: Text("Commercial Register Uploaded Successfully"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          });
    }
  }

  Future<void> addBussinessInfo() async {
    final url = Uri.parse('${AppConfig.baseUrl}/business-info');
    final List<String>? selectedServices =
        _selectedServices?.map((value) => value.toString()).toList();

    final requestBody = {
      'enCompanyName': _englishNameController.text,
      'arCompanyName': _arabicNameController.text,
      'salesChannelName': _salesChannelNameController.text != ''
          ? _salesChannelNameController.text
          : null,
      'salesChannelURL':
          _storeURLController.text != '' ? _storeURLController.text : null,
      'salesChannelTypeID': int.parse(_selectedSalesChannel.toString()),
      'productTypeID': int.parse(_selectedProduct.toString()),
      'prefix': _prefixController.text != '' ? _prefixController.text : null,
      'streetName': _streetNameController.text,
      'apartmentNumber': _apartmentNumberController.text,
      'floorNumber': _floorNumberController.text,
      'buildingNumber': _buildingNumberController.text,
      'cityID': int.parse(_selectedCity.toString()),
      'serviceTypesIDs': selectedServices,
      'nationalID': _nationalID,
      'commercialRegister': _commercialRegister,
    };

    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      if (jsonData == "Prefix Already Exists") {
        // Show a dialog with the message
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text("Prefix Already Exists"),
              actions: <Widget>[
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                ),
              ],
            );
          },
        );
      } else {
        final urlUpdate =
            Uri.parse('${AppConfig.baseUrl}/subAccounts-verification/verify/2');
        await http.put(urlUpdate, headers: AppConfig.headers);
        Navigator.pop(context); // Go back once
        Navigator.pop(context); // Go back again
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void _updateButtonEnabledStatus() {
    setState(() {
      _isButtonEnabled = _englishNameController.text.isNotEmpty &&
          _arabicNameController.text.isNotEmpty &&
          _streetNameController.text.isNotEmpty &&
          _buildingNumberController.text.isNotEmpty &&
          _floorNumberController.text.isNotEmpty &&
          _apartmentNumberController.text.isNotEmpty &&
          _selectedSalesChannel != null &&
          _selectedProduct != null &&
          _selectedCity != null &&
          _nationalID != null &&
          _commercialRegister != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Info'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
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
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Business Name (English)",
                                ),
                                onChanged: (englishName) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _arabicNameController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Business Name (Arabic)',
                                ),
                                onChanged: (arabicName) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
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
                                  labelText: 'Sales Channels',
                                ),
                                child: Container(
                                  height: 20,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedSalesChannel,
                                      onChanged: !_dataExists
                                          ? (newValue) {
                                              setState(() {
                                                _selectedSalesChannel =
                                                    newValue!;
                                              });
                                              _updateButtonEnabledStatus();
                                            }
                                          : null,
                                      items: _salesChannels
                                          .map<DropdownMenuItem<String>>(
                                              (Map<String, dynamic> value) {
                                        return DropdownMenuItem<String>(
                                          value: value['Sales Channeel Type ID']
                                              .toString(),
                                          child: Text(
                                              value['Sales Channeel Type']),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _salesChannelNameController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Sales Channel Name',
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _storeURLController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Store URL',
                                ),
                              ),
                            ),
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
                                  labelText: 'Product',
                                ),
                                child: Container(
                                  height: 20,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedProduct,
                                      onChanged: !_dataExists
                                          ? (newValue) {
                                              setState(() {
                                                _selectedProduct = newValue!;
                                              });
                                              _updateButtonEnabledStatus();
                                            }
                                          : null,
                                      items: _products
                                          .map<DropdownMenuItem<String>>(
                                              (Map<String, dynamic> value) {
                                        return DropdownMenuItem<String>(
                                          value: value['ID'].toString(),
                                          child: Text(value['enProduct']),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _prefixController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Prefix",
                                ),
                              ),
                            ),
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
                                  labelText: 'City',
                                ),
                                child: Container(
                                  height: 20,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedCity,
                                      onChanged: !_dataExists
                                          ? (newValue) {
                                              setState(() {
                                                _selectedCity = newValue!;
                                              });
                                              _updateButtonEnabledStatus();
                                            }
                                          : null,
                                      items:
                                          _cities.map<DropdownMenuItem<String>>(
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
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _streetNameController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Street Name",
                                ),
                                onChanged: (streetName) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _buildingNumberController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Building Number",
                                ),
                                onChanged: (buildingNumber) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _floorNumberController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Floor Number",
                                ),
                                onChanged: (floorNumber) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _apartmentNumberController,
                                readOnly: _dataExists,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "Apartment Number",
                                ),
                                onChanged: (apartmentNumber) {
                                  _updateButtonEnabledStatus();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A)),
                                  ),
                                  labelText: 'Services',
                                ),
                                child: IgnorePointer(
                                  ignoring: _dataExists,
                                  child: MultiSelectDialogField(
                                    initialValue: _selectedServices,
                                    items: _services
                                        .map((e) => MultiSelectItem(
                                            e['Service Type ID'],
                                            e['Service Type'].toString()))
                                        .toList(),
                                    listType: MultiSelectListType.CHIP,
                                    onConfirm: (selectedItems) {
                                      setState(() {
                                        _selectedServices =
                                            List<int>.from(selectedItems);
                                      });
                                    },
                                    buttonText: !_dataExists
                                        ? Text('Select Services')
                                        : Text(''),
                                    chipDisplay: MultiSelectChipDisplay(),
                                    searchHint: 'Search Services',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: !_dataExists
                                      ? Theme.of(context).primaryColor
                                      : const Color.fromARGB(249, 95, 95, 95)),
                              onPressed: !_dataExists
                                  ? () {
                                      _pickIDImage();
                                    }
                                  : null,
                              child: Text("Upload National ID"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: !_dataExists
                                      ? Theme.of(context).primaryColor
                                      : const Color.fromARGB(249, 95, 95, 95)),
                              onPressed: !_dataExists
                                  ? () {
                                      _pickCommercialRegisterImage();
                                    }
                                  : null,
                              child: Text("Upload Commercial Register"),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: !_dataExists,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _dataExists
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
                                      addBussinessInfo();
                                    }
                                  }
                                : null, // Disable the button if fields are not valid
                            child: const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: Text('Submit'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
