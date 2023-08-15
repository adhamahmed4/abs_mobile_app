import 'package:abs_mobile_app/More/Settings/BusinessInfo/businessInfo.dart';
import 'package:abs_mobile_app/More/Settings/PersonalInfo/personalInfo.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Add border radius
              child: Container(
                color: Colors.grey.shade200,
                child: ListTileTheme(
                  iconColor: Colors.black,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.account_circle_outlined),
                        title: Text('Personal Info'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(
                                  milliseconds:
                                      300), // Adjust the animation duration
                              pageBuilder: (_, __, ___) => PersonalInfoPage(),
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
                        leading: Icon(Icons.business_outlined),
                        title: Text('Business Info'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(
                                  milliseconds:
                                      300), // Adjust the animation duration
                              pageBuilder: (_, __, ___) => BusinessInfoPage(),
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
                        leading: Icon(Icons.request_quote_outlined),
                        title: Text('Pricing Plan'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Handle profile tap
                        },
                      ),
                      Divider(),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.payment_outlined),
                        title: Text('Payment Methods'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Handle email tap
                        },
                      ),
                      Divider(),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.my_location_outlined),
                        title: Text('Pickup Locations'),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          // Handle location tap
                        },
                      ),
                      Divider(),
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.language_outlined),
                        title: Text('Language'),
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
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12), // Add border radius
              child: Container(
                color: Color.fromARGB(255, 255, 233, 233),
                child: ListTileTheme(
                  iconColor: Colors.red,
                  child: Column(
                    children: [
                      ListTile(
                        tileColor: Colors.white,
                        leading: Icon(Icons.person_remove),
                        title: Text(
                          'Delete account',
                          style: TextStyle(
                            color: Colors.red, // Set the font color to red
                          ),
                        ),
                        onTap: () {
                          // Handle email tap
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
    );
  }
}
