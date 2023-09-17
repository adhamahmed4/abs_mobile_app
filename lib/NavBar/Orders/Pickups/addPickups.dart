import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPickupPage extends StatefulWidget {
  @override
  _AddPickupPageState createState() => _AddPickupPageState();
}

class _AddPickupPageState extends State<AddPickupPage> {
  List<dynamic> pickupLocations = [];
  List<dynamic> vehicleTypes = [];
  String? selectedVehicleType;
  String? selectedLocation; // Default selected location
  List<DateTime> datePoints = [];
  DateTime? startDate;
  DateTime? endDate;
  bool selectingDateRange = false;
  int _numberOfItems = 1;

  TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateDatePoints();
    getPickupLocations();
    getVehicleTypes();
  }

  Future<void> getPickupLocations() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/pickup-return-locations-by-subAccountID');
    final body = {"locationType": "Pickup"};
    final jsonBody = json.encode(body);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          pickupLocations = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'ID': item["ID"],
              'Location Name': item['Location Name'],
              'Address': item['Address'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> getVehicleTypes() async {
    final url = Uri.parse('${AppConfig.baseUrl}/vehicle-types/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          vehicleTypes = jsonData.map<Map<String, dynamic>>((dynamic item) {
            return {
              'Vehicle Type ID': item['Vehicle Type ID'],
              'Vehicle Type': item['Vehicle Type'],
            };
          }).toList();
        });
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  void generateDatePoints() {
    // Initialize datePoints with today and the coming 10 days (excluding Fridays)
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      if (currentDate.weekday != DateTime.friday) {
        datePoints.add(currentDate);
      }
      currentDate = currentDate.add(Duration(days: 1));
    }
  }

  String formatDate(DateTime date) {
    final DateFormat dateFormat = DateFormat('EEE, MMM d');
    return dateFormat.format(date);
  }

  bool isDateSelected(DateTime date) {
    // Check if the date is within the selected date range
    if (startDate != null && endDate != null) {
      return date.isAfter(startDate!) && date.isBefore(endDate!);
    }
    return false;
  }

  Future<void> addPickup() async {
    final url = Uri.parse('${AppConfig.baseUrl}/create-pickup');

    // Extract selected values from your state variables
    final pickupLocationID = selectedLocation;
    final vehicleTypeID = selectedVehicleType;
    final timeFrom = startDate;
    final toTime = endDate;
    final notes = _notesController.text;
    final noOfAWBs = _numberOfItems;

    // Check if all required values are non-null
    if (pickupLocationID != null &&
        vehicleTypeID != null &&
        timeFrom != null &&
        toTime != null) {
      final requestBody = {
        "pickupLocationID": pickupLocationID,
        "pickupTypeID": 1, // Leave it as 1
        "vehicleTypeID": vehicleTypeID,
        "timeFrom": DateFormat('yyyy-MM-dd').format(timeFrom),
        "toTime": DateFormat('yyyy-MM-dd').format(toTime),
        "Notes": notes,
        "noOfAWBs": noOfAWBs.toString(),
      };

      final jsonBody = json.encode(requestBody);
      final response =
          await http.post(url, headers: AppConfig.headers, body: jsonBody);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        Navigator.pop(context);
        print(jsonData);
      } else {
        throw Exception('Failed to Create Pickup');
      }
    } else {
      // Handle the case where some required values are null
      print('Please select all required values');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      appBar: AppBar(
        title: const Text(
          'Create new pickup',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: const <Widget>[],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const Text(
                        'The courier will come soon to pick your orders',
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Select location and date for pickup',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Image.asset(
                        'assets/images/createPickUp.png', // Replace with your image path
                        height: 200, // Adjust the height as needed
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20, // Adjust the size as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Pickup location',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: SizedBox(
                          width: 500,
                          child: Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF2B2E83).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: DropdownButton<String>(
                                value: selectedLocation,
                                items: pickupLocations.map((location) {
                                  return DropdownMenuItem<String>(
                                    value: location["ID"].toString(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 6, 8, 0),
                                          child: Text(
                                            location["Location Name"] ?? '',
                                            style: const TextStyle(
                                              color: Color(0xFF2B2E83),
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              18, 0, 8, 2),
                                          child: Text(
                                            location["Address"],
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 8.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedLocation = newValue ?? '';
                                  });
                                },
                              )),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 20, // Adjust the size as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Pickup date range',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const Row(
                        children: [
                          Text(
                            'Scroll to view more',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey, // Adjust the color as needed
                            ),
                          ),
                          Icon(
                            Icons.arrow_right_alt,
                            size: 20, // Adjust the size as needed
                            color: Colors.grey, // Adjust the color as needed
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection:
                              Axis.horizontal, // Display items horizontally
                          itemCount: datePoints.length,
                          itemBuilder: (context, index) {
                            final date = datePoints[index];
                            final formattedDate = DateFormat('d').format(date);
                            final dayName = DateFormat('E').format(date);
                            final month = DateFormat('MMM').format(date);
                            return Card(
                              color: (startDate != null &&
                                          endDate != null &&
                                          date.isAfter(startDate!) &&
                                          date.isBefore(endDate!)) ||
                                      (startDate != null &&
                                          endDate ==
                                              date) // Highlight the end date and in-between dates
                                  ? Colors
                                      .blue // Change to the color you want for selected dates
                                  : (startDate != null && date == startDate!)
                                      ? Colors
                                          .blue // Highlight only the start date
                                      : Color.fromARGB(255, 228, 228, 228),
                              elevation: 2.0,
                              margin: EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    if (selectingDateRange) {
                                      if (date.isBefore(startDate!)) {
                                        endDate = startDate;
                                        startDate = date;
                                      } else {
                                        endDate = date;
                                      }
                                      selectingDateRange = false;
                                    } else {
                                      startDate = date;
                                      selectingDateRange = true;
                                    }
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        month,
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '$formattedDate, $dayName',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Colors.black, // Change text color
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.directions_car_outlined,
                            size: 20, // Adjust the size as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Vehicle Type',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 320,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF2B2E83).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: DropdownButton<String>(
                              value: selectedVehicleType,
                              items: vehicleTypes.map((type) {
                                return DropdownMenuItem<String>(
                                  value: type["Vehicle Type ID"].toString(),
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 8, 40, 8),
                                    child: Text(
                                      type["Vehicle Type"],
                                      style: const TextStyle(
                                        color: Color(0xFF2B2E83),
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedVehicleType =
                                      newValue ?? 'Default Vehicle Type';
                                });
                              },
                              icon: const Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(150, 0, 0, 0),
                                child: Icon(
                                  Icons.keyboard_arrow_down,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 20, // Adjust the size as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Number of items',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Row(
                          children: [
                            const Text('Number of items'),
                            const Spacer(),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      setState(() {
                                        if (_numberOfItems > 1) {
                                          _numberOfItems--;
                                        }
                                      });
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(8, 0, 8, 0),
                                    child: Text('$_numberOfItems'),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      setState(() {
                                        _numberOfItems++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.notes_outlined,
                            size: 20, // Adjust the size as needed
                            color: Colors.black, // Adjust the color as needed
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'Notes',
                            style: TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                          height:
                              16), // Add some spacing between the title and the text area
                      TextField(
                        controller: _notesController,
                        maxLines: 4, // Allow multiple lines of text
                        decoration: const InputDecoration(
                          hintText: 'Enter your notes here', // Add a hint text
                          border:
                              OutlineInputBorder(), // Add a border around the text area
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  addPickup();
                },
                child: const Text('Create Pickup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
