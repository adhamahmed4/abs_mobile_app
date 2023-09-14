import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:abs_mobile_app/Track/time_line_tile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends State<TrackPage> {
  String searchValue = "";
  List<dynamic> shipmentHistory = [];

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Future<void> fetchShipmentHistory() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/track-shipment/all/$searchValue');
      final response = await http.get(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            shipmentHistory = data;
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
          backgroundColor: Color.fromARGB(255, 244, 246, 248),
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchValue = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Enter tracking number',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Call the function to fetch shipment history.
                    fetchShipmentHistory();
                  },
                ),
              ),
            ),
          ),
          if (shipmentHistory.isNotEmpty)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ListView(
                  children: const [
                    MyTimeLineTile(
                      isFirst: true,
                      isLast: false,
                      isCurrent: true,
                      isPast: true,
                      text: "New Shipment",
                    ),
                    MyTimeLineTile(
                      isFirst: false,
                      isLast: false,
                      isCurrent: false,
                      isPast: false,
                      text: "In Transit",
                    ),
                    MyTimeLineTile(
                      isFirst: false,
                      isLast: false,
                      isCurrent: false,
                      isPast: false,
                      text: "Out For Delivery",
                    ),
                    MyTimeLineTile(
                      isFirst: false,
                      isLast: true,
                      isCurrent: false,
                      isPast: false,
                      text: "Delivered",
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
