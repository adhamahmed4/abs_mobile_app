import 'dart:io';
import 'package:abs_mobile_app/More/Settings/BusinessLocations/addBusinessLocation.dart';
import 'package:abs_mobile_app/More/Settings/BusinessLocations/maps.dart';
import 'package:flutter/material.dart';
import '../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class BusinessLocationsPage extends StatefulWidget {
  @override
  _BusinessLocationsPageState createState() => _BusinessLocationsPageState();
}

class _BusinessLocationsPageState extends State<BusinessLocationsPage> {
  List<dynamic>? locations = [];
  bool isLoading = true;

  Future<void> getBusinessLocations() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/cust-addresses-by-subAccountID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            locations = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            locations = [];
            isLoading = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getBusinessLocations();
  }

  Color _getColorForLocationType(String locationType) {
    switch (locationType) {
      case 'Pickup':
        return Colors.orange;
      case 'Return':
        return Colors.blue;
      case 'Company':
        return Colors.deepPurple;
      default:
        return Colors.grey; // You can set a default color for other cases
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Locations'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Card(
                      margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'New Locations',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            const Text(
                              'Manage your locations to control your shipment\'s pickup and return destinations.',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(
                                          milliseconds:
                                              300), // Adjust the animation duration
                                      pageBuilder: (_, __, ___) =>
                                          AddNewLocationPage(
                                        locationID: 0,
                                      ),
                                      transitionsBuilder: (_,
                                          Animation<double> animation,
                                          __,
                                          Widget child) {
                                        return SlideTransition(
                                          position: Tween<Offset>(
                                            begin: Offset(1.0, 0.0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  ).then((_) {
                                    // This code block will execute when returning from AddNewLocationPage.
                                    getBusinessLocations();
                                  });
                                },
                                child: const Text('+ Add new location'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    locations!.isEmpty
                        ? Container()
                        : Card(
                            margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: locations!.map((location) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.circular(18.0),
                                    child: Card(
                                      color: const Color.fromARGB(
                                          255, 226, 226, 226),
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                PageRouteBuilder(
                                                  transitionDuration: Duration(
                                                      milliseconds: 300),
                                                  pageBuilder: (_, __, ___) =>
                                                      AddNewLocationPage(
                                                    locationID: location["ID"],
                                                  ),
                                                  transitionsBuilder: (_,
                                                      Animation<double>
                                                          animation,
                                                      __,
                                                      Widget child) {
                                                    return SlideTransition(
                                                      position: Tween<Offset>(
                                                        begin: Offset(1.0, 0.0),
                                                        end: Offset.zero,
                                                      ).animate(animation),
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                              ).then((_) {
                                                getBusinessLocations();
                                              });
                                            },
                                            child: ListTile(
                                              title: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      location["Location Name"],
                                                      style: const TextStyle(
                                                        fontSize: 14.0,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 8.0),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0,
                                                          vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color: _getColorForLocationType(
                                                            location[
                                                                "Location Type"]),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Text(
                                                        location[
                                                            "Location Type"],
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        width:
                                                            8.0), // Add some space between badges
                                                    Expanded(
                                                      child:
                                                          Container(), // Empty Expanded widget to push content to the right
                                                    ),
                                                    Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 4.0,
                                                          vertical: 4.0),
                                                      decoration: BoxDecoration(
                                                        color:
                                                            location["isActive"]
                                                                ? Colors.green
                                                                : Colors.red,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      child: Text(
                                                        location["isActive"]
                                                            ? 'Active'
                                                            : 'Inactive',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10.0,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              subtitle: Text(
                                                location["Address"],
                                                style: TextStyle(
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                  ],
                ),
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
