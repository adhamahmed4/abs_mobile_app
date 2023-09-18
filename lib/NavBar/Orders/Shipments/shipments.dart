import 'package:abs_mobile_app/NavBar/Orders/Shipments/addShipments.dart';
import 'package:abs_mobile_app/Track/track.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ShipmentsPage extends StatefulWidget {
  @override
  _ShipmentsPageState createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  List<dynamic> _shipments = [];

  int _shipmentsLimit = 5;

  bool isClicked = false;

  bool isLoading = true;

  Future<void> getShipments() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/transactions-for-client-by-subAccountID/$_shipmentsLimit');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _shipments = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _shipments = [];
            isLoading = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  String formatDateTime(String dateTimeString) {
    if (dateTimeString == "") {
      return "No Date";
    }
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    getShipments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 226, 226, 226),
      body: Stack(
        children: [
          if (!isLoading)
            Center(
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 0, 12),
                        child: Row(
                          children: [
                            const Text('Shipments',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.fromLTRB(12, 2, 12, 2),
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _shipments.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 8, 0),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                elevation: 2,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                                  child: Row(
                                    children: [
                                      Icon(Icons.filter_list,
                                          color: Colors.black, size: 18),
                                      SizedBox(width: 8),
                                      Text(
                                        'Filter',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_shipments.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              8,
                              0,
                              8,
                              !isClicked &&
                                          _shipments.length + 5 ==
                                              _shipmentsLimit ||
                                      _shipments.length == _shipmentsLimit
                                  ? 0
                                  : 82),
                          child: Column(
                            children: _shipments.map((shipment) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (_, __, ___) => TrackPage(
                                        awb: shipment["AWB"],
                                      ),
                                      transitionsBuilder: (_,
                                          Animation<double> animation,
                                          __,
                                          Widget child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              '${shipment["AWB"]}',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              decoration: BoxDecoration(
                                                color: const Color.fromARGB(
                                                    255, 203, 255, 251),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                shipment["Status"],
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              shipment["Consignee Name"],
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const Spacer(),
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      10, 2, 10, 2),
                                              decoration: BoxDecoration(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Text(
                                                '${shipment["Cash"].abs()} EGP',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              shipment[
                                                      "Consignee Phone Number"] ??
                                                  '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              shipment["Consignee Phone Number"] !=
                                                          null &&
                                                      shipment[
                                                              "Consignee City"] !=
                                                          null
                                                  ? '|'
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              shipment["Consignee City"] ?? '',
                                              style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      if (!isClicked &&
                              _shipments.length + 5 == _shipmentsLimit ||
                          _shipments.length == _shipmentsLimit)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    isClicked = true;
                                    _shipmentsLimit += 5;
                                    getShipments();
                                  });
                                }
                              },
                              child: const Text(
                                'Load More',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_shipments.isEmpty)
                        const Center(
                          child: Text(
                            'No Upcoming Pickups',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => AddShipmentPage(),
                    transitionsBuilder:
                        (_, Animation<double> animation, __, Widget child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
