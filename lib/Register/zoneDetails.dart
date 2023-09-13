import 'dart:io';
import 'package:abs_mobile_app/More/Settings/PersonalInfo/ChangePassword/changePassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../Configurations/app_config.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class ZoneDetailsPage extends StatefulWidget {
  @override
  _ZoneDetailsPageState createState() => _ZoneDetailsPageState();
}

class _ZoneDetailsPageState extends State<ZoneDetailsPage> {
  List<dynamic> zones = [];

  bool isLoading = true;

  Future<void> getZones() async {
    final url = Uri.parse('${AppConfig.baseUrl}/zones/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      setState(() {
        zones = jsonData;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading:
        false;
      });
      throw Exception('Failed to load data');
    }
  }

  Future<List<dynamic>> getZoneCities(int zoneID) async {
    final url = Uri.parse('${AppConfig.baseUrl}/cities-by-zone-id/$zoneID/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getZones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zones Details'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Column(
                children: zones
                    .map(
                      (zone) => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  zone['Zone'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                future: getZoneCities(zone[
                                    'Zone ID']), // Fetch cities for this zone
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Show loading indicator while fetching cities
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    final cities =
                                        snapshot.data as List<dynamic>;
                                    return Wrap(
                                      spacing:
                                          8.0, // Adjust spacing between cities as needed
                                      runSpacing:
                                          8.0, // Adjust run spacing as needed
                                      children: cities.map((city) {
                                        return InkWell(
                                          onTap: () {
                                            // Handle city tap if needed
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: Colors.orange,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      20), // Oval background
                                            ),
                                            child: Text(
                                              city['City Name'],
                                              style: TextStyle(
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
