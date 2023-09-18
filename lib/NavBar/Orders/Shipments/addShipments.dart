import 'package:abs_mobile_app/NavBar/Orders/Shipments/delivery.dart';
import 'package:abs_mobile_app/NavBar/Orders/Shipments/exchange.dart';
import 'package:abs_mobile_app/NavBar/Orders/Shipments/return.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

class AddShipmentPage extends StatefulWidget {
  @override
  _AddShipmentPageState createState() => _AddShipmentPageState();
}

class _AddShipmentPageState extends State<AddShipmentPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create new shipment',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: ToggleSwitch(
                  initialLabelIndex: _currentIndex,
                  minWidth: 120.0,
                  cornerRadius: 10.0,
                  minHeight: 27.0,
                  labels: const ['Delivery', 'Return', 'Exchange'],
                  onToggle: (index) {
                    setState(() {
                      _currentIndex = index!;
                    });
                  },
                  borderColor: const [Color.fromARGB(255, 227, 227, 227)],
                  activeBgColor: const [Colors.white],
                  activeFgColor: Colors.black,
                  inactiveBgColor: const Color.fromARGB(255, 227, 227, 227),
                  radiusStyle: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: _currentIndex == 0
                ? DeliveryPage()
                : _currentIndex == 1
                    ? ReturnPage()
                    : ExchangePage(),
          ),
        ],
      ),
    );
  }
}
