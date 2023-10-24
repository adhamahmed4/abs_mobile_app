// Import the necessary packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:abs_mobile_app/Configurations/app_config.dart';

class CurrentShipmentsPage extends StatefulWidget {
  const CurrentShipmentsPage({Key? key}) : super(key: key);

  @override
  _CurrentShipmentsPageState createState() => _CurrentShipmentsPageState();
}

class _CurrentShipmentsPageState extends State<CurrentShipmentsPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _shipmentsData = [];

  @override
  void initState() {
    super.initState();
    _loadShipments();
  }

  Future<void> _loadShipments() async {
    try {
      var shipments = await getShipments();
      setState(() {
        _shipmentsData = shipments;
      });
    } catch (e) {
      // Handle error
    }
  }

  String getDaysDifference(expectedDeliveryDate) {
    DateTime expectedDate = DateTime.parse(expectedDeliveryDate);
    DateTime currentDate = DateTime.now();
    int daysDifference = expectedDate.difference(currentDate).inDays;
    return '$daysDifference days';
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Future<List<Map<String, dynamic>>> getShipments() async {
    final url = Uri.parse('${AppConfig.baseUrl}/shipments-courier/5');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;
      return List<Map<String, dynamic>>.from(responseBody);
    } else {
      throw Exception('Failed to get shipment info');
    }
  }

  String _scanBarcode = 'Unknown';
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

  void _launchGoogleMaps(double latitude, double longitude) async {
    Uri googleMapsUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      throw 'Could not launch Google Maps';
    }
  }

  // Function to show the AlertDialog
  void _showDetailsDialog(
      String deliveryContactPerson,
      String deliveryAddress,
      String deliveryContactNumber,
      int cash,
      String awb,
      String product,
      String packageType,
      int noOfPcs,
      String contents,
      int weight,
      String notes,
      String expectedDeliveryDate) {
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
                      Text(
                        'Expected to be delivered in ${getDaysDifference(expectedDeliveryDate)}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                        ),
                      ),
                      _buildSectionHeader('Order Details'),
                      _buildDetailItem('AWB', awb),
                      _buildDetailItem('Product Type', product),
                      _buildDetailItem('Cash', cash.toString()),
                      _buildDetailItem('Package Type', packageType),
                      _buildDetailItem('No. of Pieces', noOfPcs.toString()),
                      _buildDetailItem('Contents', contents),
                      _buildDetailItem('Weight', weight.toString()),
                    ],
                  ),
                ],
              ),
              _buildSectionHeader('User Details'),
              _buildDetailItem('Name', deliveryContactPerson),
              _buildDetailItem('Address', deliveryAddress),
              _buildDetailItem('Phone Number', deliveryContactNumber),
              const SizedBox(height: 15),
              _buildSectionHeader('Notes'),
              Text(notes,
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
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
      String name,
      String address,
      String phoneNumber,
      String awb,
      String status,
      int cash,
      String packageType,
      int noOfPcs,
      String contents,
      int weight,
      String notes,
      String lastChangeDate,
      String expectedDeliveryDate,
      String product,
      {double latitude = 0.0,
      double longitude = 0.0}) {
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
              Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 12,
                            color: status == 'Delivery'
                                ? Colors.green
                                : Colors.red,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            status,
                            style: TextStyle(
                              fontSize: 16,
                              color: status == 'Delivery'
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        awb,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatDateTime(lastChangeDate),
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
                      _showDetailsDialog(
                          name,
                          address,
                          phoneNumber,
                          cash,
                          awb,
                          product,
                          packageType,
                          noOfPcs,
                          contents,
                          weight,
                          notes,
                          expectedDeliveryDate);
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
                        'assets/images/courier2.png',
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
                  _launchGoogleMaps(latitude, longitude);
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
                      minimumSize:
                          Size(double.infinity, 45), // Set the desired height
                    ),
                    onPressed: () {
                      // Details button action
                    },
                    child: const Text(
                      'Undelivered',
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
                      'Delivered',
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
            child: ListView.builder(
              itemCount: _shipmentsData.length,
              itemBuilder: (context, index) {
                var shipment = _shipmentsData[index];
                double? latitude = shipment['latitude'] as double? ?? 0.0;
                double? longitude = shipment['longitude'] as double? ?? 0.0;

                return Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: _CourierCard(
                    shipment['service'] == 'Delivery'
                        ? shipment['deliveryContactPerson'] as String
                        : shipment['returnContactPerson'] as String,
                    shipment['service'] == 'Delivery'
                        ? shipment['deliveryAddress'] as String
                        : shipment['returnAddress'] as String,
                    shipment['service'] == 'Delivery'
                        ? shipment['deliveryContactNumber'] as String
                        : shipment['returnContactNumber'] as String,
                    shipment['AWB'] as String,
                    shipment['service'] as String,
                    shipment['Cash'].abs() as int,
                    shipment['packageType'] as String,
                    shipment['noOfPcs'] as int,
                    shipment['contents'] as String,
                    shipment['actualWeight'] as int,
                    shipment['specialInstructions'] as String,
                    shipment['lastChangeDate'] as String,
                    shipment['expectedDeliveryDate'] as String,
                    shipment['product'] as String,
                    latitude: latitude,
                    longitude: longitude,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
