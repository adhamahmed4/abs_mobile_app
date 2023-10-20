import 'package:abs_mobile_app/Login/login.dart';
import 'package:flutter/material.dart';

import 'package:abs_mobile_app/Courier/Home/home.dart';
import 'package:abs_mobile_app/Courier/Pickups/pickups.dart';
import 'package:abs_mobile_app/Courier/Shipments/shipments.dart';
import 'package:abs_mobile_app/Courier/History/history.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum DrawerPage { Home, Shipments, Pickups, History, Profile, Logout }

class DrawerNavigation extends StatefulWidget {
  final DrawerPage currentPage;

  DrawerNavigation({required this.currentPage});

  @override
  _DrawerNavigationState createState() => _DrawerNavigationState();
}

class _DrawerNavigationState extends State<DrawerNavigation> {
  void navigateToPickupsPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => PickupsPage(),
      ),
    );
  }

  void navigateToHistoryPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HistoryPage(),
      ),
    );
  }

  void navigateToShipmentsPage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ShipmentsPage(),
      ),
    );
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Center(child: Text(AppLocalizations.of(context)!.confirmLogout)),
          content:
              Text(AppLocalizations.of(context)!.areYouSureYouWantToLogout),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  AppLocalizations.of(context)!.cancel,
                )),
            TextButton(
              onPressed: () async {
                final prefs = await SharedPreferences.getInstance();
                await prefs.clear();
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                AppLocalizations.of(context)!.logout,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void navigateToPage(BuildContext context, DrawerPage page) {
    switch (page) {
      case DrawerPage.Home:
        navigateToHomePage(context);
        break;
      case DrawerPage.Shipments:
        navigateToShipmentsPage(context);
        break;
      case DrawerPage.Pickups:
        navigateToPickupsPage(context);
        break;
      case DrawerPage.History:
        navigateToHistoryPage(context);
        break;
      case DrawerPage.Logout:
        logout(context);
        break;
      // Add cases for Profile and Logout if needed
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 16, 0, 8),
            child: CircleAvatar(
              radius: 50,
              child: Icon(
                Icons.person,
                size: 50,
              ),
            ),
          ),
          Center(
            child: Text(
              'Adham Ahmed',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              'Maadi Branch',
              style: TextStyle(color: Color.fromARGB(255, 114, 114, 114)),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Divider(
            color: Colors.grey,
          ),
          // ListTile for Home
          buildDrawerItem(DrawerPage.Home, Icons.home, 'Home'),
          Divider(
            // Add a divider between the widgets
            color: Colors.grey[600],
          ),

          // ListTile for Shipments
          buildDrawerItem(
              DrawerPage.Shipments, Icons.local_shipping, 'Shipments'),
          Divider(
            // Add a divider between the widgets
            color: Colors.grey[600],
          ),
          // ListTile for Pickups
          buildDrawerItem(DrawerPage.Pickups, Icons.delivery_dining, 'Pickups'),
          Divider(
            // Add a divider between the widgets
            color: Colors.grey[600],
          ),
          // ListTile for History
          buildDrawerItem(DrawerPage.History, Icons.history, 'History'),
          Divider(
            // Add a divider between the widgets
            color: Colors.grey[600],
          ),
          // ListTile for Profile
          buildDrawerItem(DrawerPage.Profile, Icons.person, 'Profile'),
          Divider(
            // Add a divider between the widgets
            color: Colors.grey[600],
          ),
          // ListTile for Logout
          buildDrawerItem(DrawerPage.Logout, Icons.logout, 'Logout'),
        ],
      ),
    );
  }

  ListTile buildDrawerItem(DrawerPage page, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        navigateToPage(context, page);
      },
      selected: widget.currentPage == page,
      // Apply different color for the selected item
      tileColor: widget.currentPage == page ? Colors.grey[200] : null,
    );
  }
}
