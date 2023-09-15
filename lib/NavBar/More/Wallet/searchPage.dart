import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  void initState() {
    super.initState();
    // Fetch data from API when the widget is initialized
  }

  TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = []; // Store the search results here

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  // Function to create InfoCard widgets for search results
  Widget buildInfoCard(String awb, String absfees, String deliveryDate,
      String paymentDate, String cash) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(8, 8, 0, 2),
              decoration: BoxDecoration(
                color: Color.fromARGB(
                    255, 255, 255, 255), // Background color for the title 'AWB'
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              width: double.infinity, // Make the container span the full width
              child: Text(
                'AWB: $awb',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: const Color.fromARGB(
                      255, 0, 0, 0), // Text color for the title 'AWB'
                ),
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Cash: $cash EGP', style: TextStyle(fontSize: 12)),
                  Text('ABS Fees: $absfees EGP',
                      style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
            Divider(),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text('Delivery Date: ${formatDateTime(deliveryDate)}',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
            SizedBox(height: 8),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text('Payment Date: ${formatDateTime(paymentDate)}',
                    style: TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchByAWB(String awb) async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-shipments/$awb');
    final headers = AppConfig.headers;
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      if (responseBody.isNotEmpty) {
        try {
          final decodedResponse =
              json.decode(responseBody) as Map<String, dynamic>;

          if (mounted) {
            setState(() {
              searchResults = [decodedResponse]; // Wrap the response in a list
            });
            print(searchResults);
          }
        } catch (e) {
          // Handle JSON parsing error
          if (mounted) {
            setState(() {
              searchResults = [];
            });
          }
        }
      } else {
        // Response body is empty, indicating no results. Show a dialog.
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('AWB Not Found'),
                content: Text('The AWB you entered was not found.'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
          setState(() {
            searchResults = [];
          });
        }
      }
    } else if (response.statusCode == 404) {
      // AWB not found
      if (mounted) {
        setState(() {
          searchResults = [];
        });
      }
    } else {
      // Handle other error cases
      throw Exception('Failed to get data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color.fromARGB(255, 244, 246, 248),
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          Row(
            children: [
              Container(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by AWB...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (awb) {
                    searchByAWB(awb); // Call the search function
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Handle search button press here if needed
                  searchByAWB(
                      _searchController.text); // Call the search function
                },
              ),
              IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  // Handle clear button press here if needed
                  setState(() {
                    searchResults.clear(); // Clear the search results
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 12),
        child: Center(
          child: searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    final result = searchResults[index];
                    return buildInfoCard(
                      result["AWB"],
                      result["ABS Fees"].toString(),
                      result["Delivery Date"],
                      result["Payment Date"],
                      result["Cash"].toString(),
                    );
                  },
                )
              : Text('No search results.'),
        ),
      ),
    );
  }
}
