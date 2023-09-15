import 'dart:io';
import 'package:abs_mobile_app/NavBar/More/Settings/PersonalInfo/ChangePassword/changePassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../Configurations/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PersonalInfoPage extends StatefulWidget {
  @override
  _PersonalInfoPageState createState() => _PersonalInfoPageState();
}

class _PersonalInfoPageState extends State<PersonalInfoPage> {
  final Dio _dio = Dio();
  bool isLoading = true;
  String? imageName;
  String? imagePath;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentPersonalInfo();
  }

  Future<void> getCurrentPersonalInfo() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users-with-info-client');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          _nameController.text = jsonData[0]['firstName'] +
              ' ' +
              jsonData[0]['lastName']; // Concatenate first and last name
          _phoneController.text = jsonData[0]['contactNumber'];
          _emailController.text = jsonData[0]['email'];
          isLoading = false;
        });
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  Future<void> _pickProfilePicture() async {
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
        filename: imageName, // Replace with the desired file name
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
      final url = Uri.parse('${AppConfig.baseUrl}/user-avatar');
      final requestBody = {'avatar': response.data['url']};
      final jsonBody = json.encode(requestBody);
      final res =
          await http.put(url, headers: AppConfig.headers, body: jsonBody);
      if (res.statusCode == 200) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Personal Info',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
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
                              controller: _nameController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A))),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: TextField(
                              controller: _phoneController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A))),
                                labelText: 'Phone',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: TextField(
                              controller: _emailController,
                              readOnly: true,
                              decoration: InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Color(0xFFFFAB4A))),
                                labelText: 'Email Address',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    _pickProfilePicture();
                                  },
                                  child: Text("Upload Profile Picture"),
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
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration: Duration(
                                            milliseconds:
                                                300), // Adjust the animation duration
                                        pageBuilder: (_, __, ___) =>
                                            ChangePasswordPage(),
                                        transitionsBuilder: (_,
                                            Animation<double> animation,
                                            __,
                                            Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    );
                                  },
                                  child: Text("Change Password"),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
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
