// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abs_mobile_app/Courier/PendingPickups/pendingPickups.dart';
import 'package:abs_mobile_app/Courier/PendingShipments/pendingShipments.dart';
import 'package:abs_mobile_app/Courier/Pickups/pickups.dart';
import 'package:abs_mobile_app/Courier/Shipments/shipments.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  const HomePage({Key? key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  void navigateToPickupsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PickupsPage(),
      ),
    );
  }

  void navigateToShipmentsPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const ShipmentsPage(),
      ),
    );
  }

  void navigateToHomePage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
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
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () => navigateToHomePage(context),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.local_shipping),
              title: Text('Shipments'),
              onTap: () => navigateToShipmentsPage(context),
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
                leading: Icon(Icons.delivery_dining),
                title: Text('Pickups'),
                onTap: () => navigateToPickupsPage(context)),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.history),
              title: Text('History'),
              onTap: null,
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: null,
            ),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: null,
            ),
          ],
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      body: Container(
        color: const Color.fromARGB(255, 237, 237, 237),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment
                        .start, // Align items to the start (left)
                    children: [
                      Builder(
                        builder: (context) => IconButton(
                          icon: Icon(Icons.menu),
                          iconSize: 30,
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(0, 0, 32, 0),
                            child: Image.asset(
                              'assets/images/logo.png',
                              width: 180,
                              height: 150,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.shipments,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(249, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .detailsOfAllYourShipments,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .pendingShipments,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '7',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.withCourier,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '20',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.delivered,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '10',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.undelivered,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '5',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.pickups,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(249, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  AppLocalizations.of(context)!
                                      .detailsOfAllYourPickups,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .pendingPickups,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '7',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.withCourier,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '20',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.picked,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '10',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.unPicked,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color.fromARGB(255, 75, 75, 75),
                                      ),
                                    ),
                                    Text(
                                      '5',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 0, 16),
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .collectedCash,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(249, 0, 0, 0),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 140),
                                      child: Container(
                                        width: 70,
                                        height: 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Color(0xFF2B2E83),
                                        ),
                                        child: Icon(
                                          Icons
                                              .account_balance_wallet, // Add the wallet icon here
                                          color: Colors.white,
                                          size: 45,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 0, 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        '500',
                                        style: const TextStyle(
                                          fontSize: 45,
                                          color: Color(0xFF2B2E83),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          AppLocalizations.of(context)!.egp,
                                          style: const TextStyle(
                                            fontSize: 30,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
