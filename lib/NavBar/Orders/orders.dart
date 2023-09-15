import 'package:abs_mobile_app/NavBar/Orders/Pickups/pickups.dart';
import 'package:abs_mobile_app/NavBar/Orders/Shipments/shipments.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OrdersPage extends StatefulWidget {
  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white, // Set your desired background color here
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: ToggleSwitch(
                  initialLabelIndex: _currentIndex,
                  minWidth: 120.0,
                  cornerRadius: 10.0,
                  minHeight: 27.0,
                  labels: const ['Shipments', 'Pickups'],
                  onToggle: (index) {
                    setState(() {
                      _currentIndex = index!;
                    });
                  },
                  borderColor: [const Color.fromARGB(255, 227, 227, 227)],
                  activeBgColor: [Colors.white],
                  activeFgColor: Colors.black,
                  inactiveBgColor: const Color.fromARGB(255, 227, 227, 227),
                  radiusStyle: true,
                ),
              ),
            ),
          ),
          // Divider(),
          Expanded(
            child: _currentIndex == 0
                ? ShipmentsPage() // Content for Shipments
                : PickupsPage(), // Content for Pickups
          ),
        ],
      ),
    );
  }
}
