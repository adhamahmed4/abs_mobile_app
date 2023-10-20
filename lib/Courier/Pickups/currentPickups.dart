// Import the necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CurrentPickupsPage extends StatefulWidget {
  const CurrentPickupsPage({Key? key}) : super(key: key);

  @override
  _CurrentPickupsPageState createState() => _CurrentPickupsPageState();
}

class _CurrentPickupsPageState extends State<CurrentPickupsPage> {
  String _scanBarcode = 'Unknown';
  final TextEditingController _searchController = TextEditingController();
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(".... adham " + barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

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
                    'assets/images/courier4.png', // Replace with the actual path to your image
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
        style: const TextStyle(
            fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Text(
      '  $label: $value',
      style: const TextStyle(fontSize: 16, color: Colors.grey),
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
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(24, 8, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ABS2018531',
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Jan 20 2023 5:30 PM',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 8, 16, 0),
                child: SizedBox(
                  width: 100,
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
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
            child: Row(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: const Color.fromARGB(255, 243, 243, 243),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/courier4.png',
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(date),
                        Text(address),
                        Text(phoneNumber),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.0),
                  ),
                  minimumSize: const Size(double.infinity, 45),
                ),
                onPressed: () {
                  // Details button action
                },
                child: const Text(
                  'Show Map',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                        side: const BorderSide(color: Colors.grey),
                      ),
                      minimumSize: const Size(
                          double.infinity, 45), // Set the desired height
                    ),
                    onPressed: () {
                      // Details button action
                    },
                    child: const Text(
                      'Unpicked',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 8), // Adjust the spacing between buttons
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      minimumSize: const Size(
                          double.infinity, 45), // Set the desired height
                    ),
                    onPressed: () {
                      scanBarcodeNormal();
                    },
                    child: const Text(
                      'Picked',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchByawb,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (awb) {
                    // searchByAWB(awb);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // searchByAWB(_searchController.text);
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.crop_free,
                  color: Colors.black,
                ),
                onPressed: () {
                  scanBarcodeNormal();
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    // searchResults.clear();
                  });
                },
              ),
            ],
          ),
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    'Adham Ahmed',
                    'Jan 20 2023 5:30 PM',
                    '65 Misr Helwan Agricultural Road, Maadi, Cairo, Egypt',
                    '01001307530',
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
        ],
      ),
    );
  }
}
