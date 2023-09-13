import 'package:abs_mobile_app/Configurations/app_config.dart';
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
        setState(() {
          shipmentHistory = data;
        });
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
        title: const Text('Track'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              Column(
                children: shipmentHistory.map((step) {
                  return TimelineItem(
                    status: step["Status"],
                    dateTime: formatDateTime(step["Date"]),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class TimelineItem extends StatelessWidget {
  final String status;
  final String dateTime;

  const TimelineItem({
    super.key,
    required this.status,
    required this.dateTime,
  });

  // Define a color scheme for different shipment statuses
  Color getStatusColor(String status) {
    switch (status) {
      case "New":
        return Colors.green;
      case "In Transit":
        return Colors.blue;
      case "Out For Delivery":
        return Colors.yellow;
      case "Delivered":
        return Colors.orange;
      case "Out For Return":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Define icons for different shipment statuses
  IconData getStatusIcon(String status) {
    switch (status) {
      case "New":
        return Icons.check_circle;
      case "In Transit":
        return Icons.directions_transit;
      case "Out For Delivery":
        return Icons.local_shipping;
      case "Delivered":
        return Icons.local_shipping;
      case "Out For Return":
        return Icons.error_outline;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Vertical line with color to join icons
          Container(
            width: 1.0, // Adjust the width of the line as needed
            height: 40.0, // Adjust the height of the line as needed
            color: getStatusColor(status),
            margin: const EdgeInsets.symmetric(
                horizontal: 12.0), // Adjust the margin as needed
          ),
          // Display the status icon with color
          Icon(
            getStatusIcon(status),
            color: getStatusColor(status),
            size: 24.0,
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(status),
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(dateTime),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
