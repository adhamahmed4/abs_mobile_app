// Import the necessary packages
import 'package:flutter/material.dart';

class CourierPage extends StatefulWidget {
  const CourierPage({Key? key}) : super(key: key);

  @override
  _CourierPageState createState() => _CourierPageState();
}

class _CourierPageState extends State<CourierPage> {
  // Function to show the AlertDialog
  void _showDetailsDialog(
      String name, String date, String address, String phoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader('Order Details'),
                      _buildDetailItem('AWB', 'dfjksj'),
                      _buildDetailItem('Status', 'delivered'),
                      _buildDetailItem('Payment', '57 EGP'),
                    ],
                  ),
                  Image.asset(
                    'assets/images/courier.png', // Replace with the actual path to your image
                    width: 150, // Adjust the width as needed
                    height: 150, // Adjust the height as needed
                  ),
                ],
              ),
              _buildSectionHeader('User Details'),
              _buildDetailItem('Name', name),
              _buildDetailItem('Address', address),
              _buildDetailItem('Phone Number', phoneNumber),
              const SizedBox(height: 15),
              _buildSectionHeader('Notes'),
              const Text(
                'This is a note.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(horizontal: 70),
                ),
                child: const Text('Back',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 4),
      child: Text(
        title,
        style: TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Text(
      '  $label: $value',
      style: TextStyle(fontSize: 16, color: Colors.grey),
    );
  }

  Widget _CourierCard(
      String name, String date, String address, String phoneNumber) {
    return Card(
      elevation: 4, // Adjust the card's elevation (shadow)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: ListTile(
              title: Text(
                'Name: $name',
                style: const TextStyle(fontSize: 20),
              ),
              trailing: SizedBox(
                width: 100, // Adjust the width as needed
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    // Call the function to show the AlertDialog
                    _showDetailsDialog(name, date, address, phoneNumber);
                  },
                  child: const Text(
                    'Details',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Date: $date'),
                  Text('Address: $address'),
                  Text('Phone Number: $phoneNumber'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 10),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onPressed: () {
                    // Details button action
                  },
                  child: const Text('Show on Map'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                  onPressed: () {
                    // Confirm button action
                  },
                  child: Text('Confirm'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      appBar: AppBar(
        title: const Text(
          'Courier',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'John Doe',
                'September 20, 2023',
                '123 Main Street, City, Country',
                '+1 (123) 456-7890',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Jane Smith',
                'September 21, 2023',
                '456 Elm Street, Town, Country',
                '+1 (987) 654-3210',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Alice Johnson',
                'September 22, 2023',
                '789 Oak Street, Village, Country',
                '+1 (555) 123-4567',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Bob Wilson',
                'September 23, 2023',
                '101 Pine Street, Suburb, Country',
                '+1 (777) 888-9999',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Eve Adams',
                'September 24, 2023',
                '202 Cedar Street, County, Country',
                '+1 (333) 444-5555',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Michael Brown',
                'September 25, 2023',
                '303 Maple Street, State, Country',
                '+1 (222) 111-0000',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: _CourierCard(
                'Sophia Taylor',
                'September 26, 2023',
                '404 Birch Street, Province, Country',
                '+1 (999) 000-1111',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
