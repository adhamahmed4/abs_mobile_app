import 'package:abs_mobile_app/NavBar/Orders/Pickups/addPickups.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class PickupsPage extends StatefulWidget {
  @override
  _PickupsPageState createState() => _PickupsPageState();
}

class _PickupsPageState extends State<PickupsPage> {
  List<dynamic> _upcomingPickups = [];
  List<dynamic> _historyPickups = [];

  int _upcomingPickupslimit = 5;
  int _historyPickupslimit = 5;

  bool upcomingClicked = false;
  bool historyClicked = false;

  bool isLoading = true;

  Future<void> getUpcomingPickups() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/upcoming-pickups/$_upcomingPickupslimit');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _upcomingPickups = jsonData;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _upcomingPickups = [];
          });
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getHistoryPickups() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/history-pickups/$_historyPickupslimit');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _historyPickups = jsonData;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _historyPickups = [];
          });
        }
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  String formatDateTime(String dateTimeString) {
    if (dateTimeString == null || dateTimeString == "") {
      return "No Date";
    }
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Future<void> loadData() async {
    await getUpcomingPickups();
    await getHistoryPickups();
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
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
                            const Text('Upcoming Pickups',
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
                                _upcomingPickups.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_upcomingPickups.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                          child: Column(
                            children: _upcomingPickups.map((pickup) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            pickup["Pickup ID"].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.orange,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 1, 8, 1),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              formatDateTime(
                                                  pickup["Creation Date"] ??
                                                      ""),
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
                                          const Icon(Icons.location_on_outlined,
                                              size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            pickup["Location Name"],
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
                              );
                            }).toList(),
                          ),
                        ),
                      if (!upcomingClicked &&
                              _upcomingPickups.length + 5 ==
                                  _upcomingPickupslimit ||
                          _upcomingPickups.length == _upcomingPickupslimit)
                        Center(
                          child: TextButton(
                            onPressed: () {
                              if (mounted) {
                                setState(() {
                                  upcomingClicked = true;
                                  _upcomingPickupslimit += 5;
                                  getUpcomingPickups();
                                });
                              }
                            },
                            child: const Text(
                              'Load More',
                              style: TextStyle(
                                color: Colors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (_upcomingPickups.isEmpty)
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
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 0, 12),
                        child: Row(
                          children: [
                            const Text('History Pickups',
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
                                _historyPickups.length.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_historyPickups.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.fromLTRB(
                              8,
                              0,
                              8,
                              !historyClicked &&
                                          _historyPickups.length + 5 ==
                                              _historyPickupslimit ||
                                      _historyPickups.length ==
                                          _historyPickupslimit
                                  ? 0
                                  : 82),
                          child: Column(
                            children: _historyPickups.map((pickup) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                elevation: 4,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 16, 16, 16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            pickup["Pickup ID"].toString(),
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red,
                                            ),
                                          ),
                                          const Spacer(),
                                          Container(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 1, 8, 1),
                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              formatDateTime(
                                                  pickup["Creation Date"]),
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
                                          const Icon(Icons.location_on_outlined,
                                              size: 16),
                                          const SizedBox(width: 6),
                                          Text(
                                            pickup["Location Name"],
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
                              );
                            }).toList(),
                          ),
                        ),
                      if (!historyClicked &&
                              _historyPickups.length + 5 ==
                                  _historyPickupslimit ||
                          _historyPickups.length == _historyPickupslimit)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 8, 40),
                          child: Center(
                            child: TextButton(
                              onPressed: () {
                                if (mounted) {
                                  setState(() {
                                    historyClicked = true;
                                    _historyPickupslimit += 5;
                                    getHistoryPickups();
                                  });
                                }
                              },
                              child: const Text(
                                'Load More',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      if (_historyPickups.isEmpty)
                        const Center(
                          child: Text(
                            'No History Pickups',
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
            bottom: 16, // Adjust this value to position the button as desired
            right: 16, // Adjust this value to position the button as desired
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 300),
                    pageBuilder: (_, __, ___) => AddPickupPage(),
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
