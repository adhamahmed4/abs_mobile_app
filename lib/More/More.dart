import 'package:abs_mobile_app/Login/login.dart';
import 'package:abs_mobile_app/More/Settings/PaymentMethods/Wallet/wallet.dart';
import 'package:abs_mobile_app/More/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Configurations/app_config.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool isLoading = true;

  TextEditingController _nameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _avatarController = TextEditingController();

  String generateAvatarLetter(String name) {
    if (name.isEmpty) return '';
    final names = name.split(" ");
    if (names.length >= 2) {
      return names[0][0] + names[1][0];
    } else if (names.length == 1) {
      return names[0][0];
    }
    return '';
  }

  Future<void> fetchUserInfo() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users-with-info-client');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      setState(() {
        _nameController.text = responseBody[0]['firstName'] +
            ' ' +
            responseBody[0]['lastName']; // Update the name controller
        _mobileController.text =
            responseBody[0]['contactNumber']; // Update the mobile controller
        _avatarController.text = responseBody[0]['avatar'] != null
            ? responseBody[0]['avatar']
            : ''; // Update the avatar controller
        isLoading = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Failed to fetch user info'),
            content: Text('Failed to fetch user info.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserInfo(); // Call the method to fetch user info on page load
  }

  @override
  Widget build(BuildContext context) {
    // final String fullName = 'Adham Ahmed';
    // final String Mobile = '+201001307530';

    return Scaffold(
      appBar: AppBar(
        title: Text('More'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                                color: Color(0xFFEEF1F5),
                                child: _avatarController.text != ''
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/profile_picture.jpg', // Placeholder image asset
                                        image:
                                            '${AppConfig.baseUrl}/images/getImage?name=${_avatarController.text}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        backgroundColor: Color(0xFFEEF1F5),
                                        radius: 40,
                                        child: Text(
                                          generateAvatarLetter(
                                              _nameController.text),
                                          style: TextStyle(fontSize: 24),
                                        ),
                                      )
                                // Image.asset(
                                //   'assets/images/profile_picture.jpg',
                                //   width: 80,
                                //   height: 80,
                                //   errorBuilder: (BuildContext context, Object exception,
                                //       StackTrace? stackTrace) {
                                //     return CircleAvatar(
                                //       backgroundColor: Color(0xFFEEF1F5),
                                //       radius: 40,
                                //       child: Text(
                                //         generateAvatarLetter(_nameController.text),
                                //         style: TextStyle(fontSize: 24),
                                //       ),
                                //     );
                                //   },
                                // ),
                                ),
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8),
                              Text(
                                _mobileController.text,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Add border radius
                      child: Container(
                        color: Colors.grey.shade200,
                        child: ListTileTheme(
                          iconColor: Colors.black,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.settings),
                                title: Text('Settings'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(
                                          milliseconds:
                                              300), // Adjust the animation duration
                                      pageBuilder: (_, __, ___) =>
                                          SettingsPage(),
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
                              ),
                              Divider(),
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.wallet),
                                title: Text('Wallet'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WalletPage()), // Navigate to WalletPage
                                  );
                                },
                              ),
                              Divider(),
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.support),
                                title: Text('Support Tickets'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  // Handle profile tap
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12), // Add border radius
                      child: Container(
                        color: Colors.grey.shade200,
                        child: ListTileTheme(
                          iconColor: Colors.black,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.text_snippet),
                                title: Text('Terms & Conditions'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  // Handle email tap
                                },
                              ),
                              Divider(),
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.policy),
                                title: Text('Privacy Policy'),
                                trailing: Icon(Icons.arrow_forward),
                                onTap: () {
                                  // Handle location tap
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Color.fromARGB(255, 255, 233, 233),
                        child: ListTileTheme(
                          iconColor: Colors.red,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: Icon(Icons.logout),
                                title: Text(
                                  'Logout',
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                            child: Text('Confirm Logout')),
                                        content: Text(
                                            'Are you sure you want to logout?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                            },
                                            child: Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.clear();
                                              Navigator.of(context)
                                                  .pop(); // Close the dialog
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
                                              );
                                            },
                                            child: Text(
                                              'Logout',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
