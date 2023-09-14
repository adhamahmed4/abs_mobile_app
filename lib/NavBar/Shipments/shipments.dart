import 'package:flutter/material.dart';

class ShipmentsPage extends StatefulWidget {
  @override
  _ShipmentsPageState createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  int _currentIndex = 0; // Index to track which button is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 244, 246, 248),
        shadowColor: Colors.transparent,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Button for 'Shipments'
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: _currentIndex == 0 ? Colors.orange : null,
                ),
                child: Text('Shipments'),
              ),
              // Button for 'Pickups'
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary: _currentIndex == 1 ? Colors.orange : null,
                ),
                child: Text('Pickups'),
              ),
            ],
          ),
          Expanded(
            child: _currentIndex == 0
                ? _buildShipmentsContent() // Content for Shipments
                : _buildPickupsContent(), // Content for Pickups
          ),
        ],
      ),
    );
  }

  // Replace these functions with your actual content for Shipments and Pickups
  Widget _buildShipmentsContent() {
    return Center(
      child: Text('Shipments Content Goes Here'),
    );
  }

  Widget _buildPickupsContent() {
    return Center(
      child: Text('Pickups Content Goes Here'),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ShipmentsPage(),
  ));
}
