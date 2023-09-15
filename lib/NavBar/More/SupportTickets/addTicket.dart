import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AddTicketPage extends StatefulWidget {
  @override
  _AddTicketPageState createState() => _AddTicketPageState();
}

class _AddTicketPageState extends State<AddTicketPage> {
  final Dio _dio = Dio();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  TextEditingController _awbController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _ticketTypes = [];

  String? _selectedTicketType;
  String? imageName;
  String? imagePath;
  String? ticketDocument;

  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    getTicketTypes();
    _updateButtonEnabledStatus();
  }

  void _updateButtonEnabledStatus() {
    if (mounted) {
      setState(() {
        _isButtonEnabled =
            _awbController.text.isNotEmpty && _selectedTicketType != null;
      });
    }
  }

  Future<void> getTicketTypes() async {
    final url = Uri.parse('${AppConfig.baseUrl}/ticket-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _ticketTypes = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'ID': item['ID'],
              'enTicketType': item['enTicketType'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _pickTicketDocument() async {
    final imagePicker = ImagePicker();
    final pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage == null) return;
    imageName = pickedImage.path.split('/').last;
    imagePath = pickedImage.path;
    final prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        imagePath!,
        filename: imageName,
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
      if (mounted) {
        setState(() {
          ticketDocument = response.data['url'];
        });
      }
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text("Image uploaded successfully"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text("Failed to upload image"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ));
    }
  }

  Future<void> addTicket() async {
    final checkUrl =
        Uri.parse('${AppConfig.baseUrl}/check-awb/${_awbController.text}');
    final checkResponse = await http.get(checkUrl, headers: AppConfig.headers);

    final checkResponseBody = json.decode(checkResponse.body);
    if (!checkResponseBody) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text("AWB not found"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("OK"),
                  ),
                ],
              ));
      return;
    }
    final url = Uri.parse('${AppConfig.baseUrl}/tickets');

    final requestBody = {
      "AWB": _awbController.text,
      "ticketTypeID": _selectedTicketType,
      "Description": _descriptionController.text,
      "documentPath": ticketDocument,
    };

    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);

    if (response.statusCode == 200) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Create Ticket',
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
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                              child: TextField(
                                controller: _awbController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: "AWB",
                                ),
                                onChanged: (awb) {
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
                                  labelText: 'Ticket Subject',
                                ),
                                child: SizedBox(
                                  height: 20,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _selectedTicketType,
                                      onChanged: (newValue) {
                                        if (mounted) {
                                          setState(() {
                                            _selectedTicketType = newValue!;
                                          });
                                        }
                                        _updateButtonEnabledStatus();
                                      },
                                      items: _ticketTypes
                                          .map<DropdownMenuItem<String>>(
                                        (Map<String, dynamic> value) {
                                          return DropdownMenuItem<String>(
                                            value: value['ID'].toString(),
                                            child: Text(value['enTicketType']),
                                          );
                                        },
                                      ).toList(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: TextField(
                                controller: _descriptionController,
                                decoration: const InputDecoration(
                                  fillColor: Color.fromARGB(255, 250, 250, 250),
                                  filled: true,
                                  border: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Color(0xFFFFAB4A))),
                                  labelText: 'Description',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        child: Column(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _pickTicketDocument();
                              },
                              child: const Text("Upload Document"),
                            ),
                          ],
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
                                    addTicket();
                                  }
                                }
                              : null,
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text('Create ticket'),
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
