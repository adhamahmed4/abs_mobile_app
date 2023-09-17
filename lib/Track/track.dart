import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/Track/time_line_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TrackPage extends StatefulWidget {
  String? awb;

  TrackPage({super.key, this.awb});
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  List<dynamic> shipmentHistory = [];
  bool isNew = false;
  bool isInTransit = false;
  bool isOutForDelivery = false;
  bool isDelivered = false;
  bool isUndelivered = false;

  String? isCurrent;

  List<dynamic> shipmentData = [];

  bool trackingNumberEntered = false;

  bool isLoading = false;

  final TextEditingController _searchController = TextEditingController();

  final TextEditingController _serviceController = TextEditingController();
  final TextEditingController _productController = TextEditingController();
  final TextEditingController _codController = TextEditingController();
  final TextEditingController _specialInstructionsController =
      TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.awb != null) {
      _searchController.text = widget.awb!;
      getShipmentHistory();
      getShipmentData();
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Future<void> getShipmentHistory() async {
    try {
      if (_searchController.text.isEmpty) return;
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final url = Uri.parse(
          '${AppConfig.baseUrl}/track-shipment/all/${_searchController.text}');
      final response = await http.get(url, headers: AppConfig.headers);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.isEmpty) {
          if (mounted) {
            setState(() {
              trackingNumberEntered = false;
              isLoading = false;
            });

            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('AWB is incorrect'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                });
            return;
          }
        }

        if (mounted) {
          setState(() {
            trackingNumberEntered = true;
            shipmentHistory = data;
            isCurrent = data.last["Status"];
          });
        }
        for (final shipment in shipmentHistory) {
          final status = shipment['Status'];

          if (status == 'New') {
            if (mounted) {
              setState(() {
                isNew = true;
              });
            }
          } else if (status == 'In Transit') {
            if (mounted) {
              setState(() {
                isInTransit = true;
              });
            }
          } else if (status == 'Out For Delivery') {
            if (mounted) {
              setState(() {
                isOutForDelivery = true;
              });
            }
          } else if (status == 'Delivered') {
            if (mounted) {
              setState(() {
                isDelivered = true;
              });
            }
          } else if (status == 'Undelivered') {
            if (mounted) {
              setState(() {
                isUndelivered = true;
              });
            }
          }
        }
        isLoading = false;
      } else {
        // Handle error cases here.
        // You can show an error message to the user.
      }
    } catch (error) {
      // Handle network or other errors.
      // You can show an error message to the user.
    }
  }

  Future<void> getShipmentData() async {
    try {
      if (_searchController.text.isEmpty) return;

      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      final url =
          Uri.parse('${AppConfig.baseUrl}/transactions-for-detail-inquiry/1');
      final requestBody = {'AWBs': _searchController.text};
      final jsonBody = json.encode(requestBody);
      final response =
          await http.post(url, headers: AppConfig.headers, body: jsonBody);

      if (response.statusCode == 200) {
        if (json.decode(response.body).isEmpty) {
          if (mounted) {
            setState(() {
              trackingNumberEntered = false;
              isLoading = false;
              return;
            });
          }
        }

        final jsonData = json.decode(response.body)[0];
        if (mounted) {
          setState(() {
            trackingNumberEntered = true;
            _serviceController.text = jsonData['Service'];
            _productController.text = jsonData['Product'];
            _codController.text = '${jsonData['Cash'].abs()} EGP';
            _specialInstructionsController.text =
                jsonData['Special Instructions'];
            _nameController.text = jsonData['Consignee'];
            _phoneNumberController.text = jsonData['ContactNumbers'];
            _addressController.text = jsonData['Consignee Address'];
          });
        }
      } else {
        // Handle error cases here.
        // You can show an error message to the user.
      }
    } catch (error) {
      // Handle network or other errors.
      // You can show an error message to the user.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Track',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Container(
        height: double.infinity,
        color: const Color.fromARGB(255, 226, 226, 226),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center vertically
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                child: Card(
                  shadowColor: Colors.transparent,
                  color: const Color.fromARGB(255, 226, 226, 226),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          width: double.infinity,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Enter your shipment number',
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
                            onSubmitted: (_) {
                              getShipmentHistory();
                              getShipmentData();
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          getShipmentHistory();
                          getShipmentData();
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            trackingNumberEntered = false;
                            isNew = false;
                            isInTransit = false;
                            isOutForDelivery = false;
                            isDelivered = false;
                            isUndelivered = false;
                            _serviceController.clear();
                            _productController.clear();
                            _codController.clear();
                            _specialInstructionsController.clear();
                            _nameController.clear();
                            _phoneNumberController.clear();
                            _addressController.clear();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Visibility(
                visible: !trackingNumberEntered && !isLoading,
                child: const Text(
                  'No Data',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey, // Customize the color
                  ),
                ),
              ),
              Visibility(
                visible: trackingNumberEntered && !isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .account_tree_rounded, // Add the icon here, this is the icon of the notification
                                  color: Colors
                                      .black, // Set the icon color as needed
                                ),
                                SizedBox(
                                    width:
                                        8), // Add some spacing between the icon and text
                                Text(
                                  'Status Tracking',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 400,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24.0),
                              child: ListView(
                                children: [
                                  MyTimeLineTile(
                                    isFirst: true,
                                    isLast: false,
                                    isCurrent: isCurrent == 'New',
                                    isPast: isNew,
                                    text: "New Shipment",
                                  ),
                                  MyTimeLineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isCurrent: isCurrent == 'In Transit',
                                    isPast: isInTransit,
                                    text: "In Transit",
                                  ),
                                  MyTimeLineTile(
                                    isFirst: false,
                                    isLast: false,
                                    isCurrent: isCurrent == 'Out For Delivery',
                                    isPast: isOutForDelivery,
                                    text: "Out For Delivery",
                                  ),
                                  MyTimeLineTile(
                                    isFirst: false,
                                    isLast: true,
                                    isCurrent: isCurrent == 'Delivered' ||
                                        isCurrent == 'Undelivered',
                                    isPast: isDelivered || isUndelivered,
                                    text: isUndelivered
                                        ? "Undelivered"
                                        : "Delivered",
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: trackingNumberEntered && !isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .local_shipping, // Add the icon here, this is the icon of the notification
                                  color: Colors
                                      .black, // Set the icon color as needed
                                ),
                                SizedBox(
                                    width:
                                        8), // Add some spacing between the icon and text
                                Text(
                                  'Shipment Details',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 4, 4),
                                  child: TextField(
                                    controller: _serviceController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      fillColor:
                                          Color.fromARGB(255, 250, 250, 250),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A)),
                                      ),
                                      labelText: 'Service',
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(4, 16, 16, 4),
                                  child: TextField(
                                    controller: _productController,
                                    readOnly: true,
                                    decoration: const InputDecoration(
                                      fillColor:
                                          Color.fromARGB(255, 250, 250, 250),
                                      filled: true,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xFFFFAB4A)),
                                      ),
                                      labelText: 'Product',
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: TextField(
                              controller: _codController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A)),
                                ),
                                labelText: 'Cash on delivery',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: TextField(
                              controller: _specialInstructionsController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A)),
                                ),
                                labelText: 'Special Instructions',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: trackingNumberEntered && !isLoading,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons
                                      .person, // Add the icon here, this is the icon of the notification
                                  color: Colors
                                      .black, // Set the icon color as needed
                                ),
                                SizedBox(
                                    width:
                                        8), // Add some spacing between the icon and text
                                Text(
                                  'Customer Details',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: TextField(
                              controller: _nameController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A)),
                                ),
                                labelText: 'Name',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
                            child: TextField(
                              controller: _phoneNumberController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A)),
                                ),
                                labelText: 'Phone Number',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                            child: TextField(
                              controller: _addressController,
                              readOnly: true,
                              decoration: const InputDecoration(
                                fillColor: Color.fromARGB(255, 250, 250, 250),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xFFFFAB4A)),
                                ),
                                labelText: 'Address',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
