import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isEmailVerified = true; // Replace with your actual logic
  bool isCompanyInfoComplete = false; // Replace with your actual logic
  bool isCompanyAddressComplete = true; // Replace with your actual l
  int totalConditionsCount = 0;
  int validatedConditionsCount = 0;
  String YourBalance = '140978';

  @override
  void initState() {
    super.initState();
    fetchCountNew();
    fetchUserName();
    fetchValidation();
  }

  Future<String> fetchUserName() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users-with-info-client');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final fullName = responseBody[0]['firstName'];
      return fullName;
    } else {
      throw Exception('Failed to fetch user info');
    }
  }

  Future<List<Map<String, dynamic>>> fetchValidation() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/subAccounts-verification-by-subAccountId');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;
      final List<Map<String, dynamic>> validationData = [];

      for (final data in responseBody) {
        validationData.add(data);
      }

      return validationData;
    } else {
      throw Exception('Failed to fetch user validations');
    }
  }

  Widget _buildStatusIndicator(bool isCompleted) {
    return Icon(
      isCompleted ? Icons.check : Icons.close,
      color: isCompleted ? Color(0xFF2B2E83) : Colors.red,
      size: 24,
    );
  }

  Widget _buildStatusRow(String title, bool isVerified) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              fontSize: 14, color: const Color.fromARGB(255, 114, 114, 114)),
        ),
        Container(
          width: 30,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isVerified ? Color(0xFF2B2E83) : Colors.grey,
          ),
          child: Icon(
            isVerified ? Icons.check : Icons.close,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(vertical: 8),
      color: Colors.grey.withOpacity(0.5),
    );
  }

  Widget _buildStatusText(String statusText, String additionalInfo) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          statusText,
          style: TextStyle(
            fontSize: 14,
            color: Color.fromARGB(255, 75, 75, 75),
          ),
        ),
        Text(
          additionalInfo, // Use InTransit Count here
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCircle(int validatedCount, int totalCount) {
    double progress = totalCount > 0 ? validatedCount / totalCount : 0.0;
    String progressText = '$validatedCount';
    String progressText2 = 'of $totalCount';

    return Container(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 74, // Adjust the width to increase the radius
            height: 74, // Adjust the height to increase the radius
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B2E83)),
              backgroundColor: Color.fromARGB(255, 214, 214, 214),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                progressText,
                style: const TextStyle(
                  color: Color(0xFF2B2E83),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                progressText2,
                style: const TextStyle(
                  color: Color.fromARGB(255, 77, 77, 77),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int getValidatedConditionsCount(List<Map<String, dynamic>> validationData) {
    int count = 0;

    for (final data in validationData) {
      final isVerified = data['isVerified'] as bool;
      if (isVerified) {
        count++;
      }
    }

    return count;
  }

  Future<String> fetchCountNew() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        final countNewData = responseBody.firstWhere(
          (statusData) => statusData['Status'] == 'New',
          orElse: () => null,
        );

        if (countNewData != null) {
          return countNewData['Count'].toString();
        } else {
          // Return a default value or an error message if 'New' status data not found
          return '0';
        }
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> countStatusValues() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status != 'Delivered' &&
              status != 'New' &&
              status != 'Returned To Shipper' &&
              status != 'Undelivered') {
            totalCount += count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> inTransitCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'In Transit') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> outForDeliveryCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'Out For Delivery') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> outForReturnCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'Out for return') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> onHoldCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'On hold') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> deliveredCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'Delivered') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> undeliveredCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'Undelivered') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  Future<int> returnedToShipperCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        int totalCount = 0;

        for (final statusData in responseBody) {
          final String status = statusData['Status'];
          final int count = statusData['Count'];

          // Check if the status is not in the excluded list
          if (status == 'Returned To Shipper') {
            totalCount = count;
          }
        }

        return totalCount;
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

  // Function to fetch "Total Cash" data
  Future<String> fetchTotalCash() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/wallet-paid-cash');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        final totalCashData =
            responseBody.isNotEmpty ? responseBody.first : null;

        if (totalCashData != null) {
          final totalCash = totalCashData['Total Cash'].toString();
          return totalCash;
        } else {
          // Return a default value or an error message if data not found
          return '0';
        }
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

// Function to fetch "ABS Fees" data
  Future<String> fetchAbsFees() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/wallet-ABS-Fees');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        final absFeesData = responseBody.isNotEmpty ? responseBody.first : null;

        if (absFeesData != null) {
          final absFees = absFeesData['ABS Fees'].toString();
          return absFees;
        } else {
          // Return a default value or an error message if data not found
          return '0';
        }
      } else {
        // Handle non-200 response status here
        print('HTTP Error: ${response.statusCode}');
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      // Handle other errors that occur during the request
      print('Error: $error');
      throw Exception('Error: $error');
    }
  }

// Function to calculate the difference between "Total Cash" and "ABS Fees"
  int calculateDifference(int totalCash, int absFees) {
    return totalCash - absFees;
  }

  @override
  Widget build(BuildContext context) {
    int validatedConditionsCount = 0;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 244, 246, 248),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/logo.png',
                width: 180,
                height: 150,
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(16, 3, 16, 16),
              child: FutureBuilder<String>(
                future: fetchUserName(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final userName = snapshot.data ?? 'Guest';
                    return Row(
                      children: [
                        Text(
                          'Hello, $userName',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 8),
                        Text('👋', style: TextStyle(fontSize: 24)),
                      ],
                    );
                  }
                },
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: fetchValidation(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  final validationData = snapshot.data ?? [];

                  // Calculate counts
                  int totalConditionsCount = validationData.length;
                  int validatedConditionsCount =
                      getValidatedConditionsCount(validationData);

                  // Check if the Row should be visible
                  bool isRowVisible =
                      validatedConditionsCount != totalConditionsCount;

                  return Visibility(
                    visible: isRowVisible,
                    child: Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: 380,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Complete your' +
                                            '\n'
                                                'account for'
                                                '\n'
                                                'a full experience',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(249, 0, 0, 0),
                                        ),
                                      ),
                                      const SizedBox(width: 70),
                                      // Build and display the status circle here using validatedConditionsCount and totalConditionsCount
                                      _buildStatusCircle(
                                          validatedConditionsCount,
                                          totalConditionsCount),
                                    ],
                                  ),
                                  // Your additional Column containing status rows
                                  Column(
                                    children: validationData.map((data) {
                                      final verificationType =
                                          data['Verification Type'] as String;
                                      final isVerified =
                                          data['isVerified'] as bool;
                                      return _buildStatusRow(
                                          verificationType, isVerified);
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),

            const SizedBox(
                height: 20), // Add spacing between the two containers
            Center(
              child: Container(
                width: 380,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shipments Overview', // Add the title here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(249, 0, 0, 0),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 50,
                                  color: Color(0xFF2B2E83),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'New Shipments',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(248, 125, 125, 125),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: FutureBuilder<String>(
                                future: fetchCountNew(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        "Error: ${snapshot.error}"); // Show error message
                                  } else {
                                    final countNew = snapshot.data;
                                    return Text(
                                      countNew ??
                                          "0", // Use the fetched count or a default value
                                      style: TextStyle(
                                        fontSize: 30,
                                        color: Color.fromARGB(248, 79, 79, 79),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 4,
                                  height: 50,
                                  color: Colors.orange,
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Processing Shipments',
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(248, 125, 125, 125),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: FutureBuilder<int>(
                                future:
                                    countStatusValues(), // Use the new function here
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text(
                                        "Error: ${snapshot.error}"); // Show error message
                                  } else {
                                    final countProcessing =
                                        snapshot.data.toString();
                                    return Text(
                                      countProcessing,
                                      style: const TextStyle(
                                        fontSize: 30,
                                        color: Color.fromARGB(248, 79, 79, 79),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
                height: 20), // Add spacing between the two containers
            Center(
              child: Container(
                width: 380,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Processing Shipments', // Add the title here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(249, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ), // Add spacing before the additional text
                    const Text(
                      'Status for all Shipments under processing', // Add your text here
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: inTransitCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final inTransitCount = snapshot.data;
                          return _buildStatusText(
                              'In transit', inTransitCount.toString());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: outForDeliveryCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final outForDeliveryCount = snapshot.data;
                          return _buildStatusText('Out for delivery',
                              outForDeliveryCount.toString());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: outForReturnCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final outForReturnCount = snapshot.data;
                          return _buildStatusText(
                              'Out for return', outForReturnCount.toString());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: onHoldCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final onHoldCount = snapshot.data;
                          return _buildStatusText(
                              'On hold', onHoldCount.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(
                height: 20), // Add spacing between the two containers
            Center(
              child: Container(
                width: 380,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Processed Shipments', // Add the title here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(249, 0, 0, 0),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ), // Add spacing before the additional text
                    const Text(
                      'Status for all processed Shipments', // Add your text here
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: deliveredCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final deliveredCount = snapshot.data;
                          return _buildStatusText(
                              'Delivered', deliveredCount.toString());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: undeliveredCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final undeliveredCount = snapshot.data;
                          return _buildStatusText(
                              'Undelivered', undeliveredCount.toString());
                        }
                      },
                    ),
                    SizedBox(height: 20),
                    FutureBuilder<int>(
                      future: returnedToShipperCount(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          final returnedToShipperCount = snapshot.data;
                          return _buildStatusText('Returned to shipper',
                              returnedToShipperCount.toString());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20), // Add spacing between the two containers
            Center(
              child: Container(
                width: 380,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Your Balance', // Add the title here
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(249, 0, 0, 0),
                          ),
                        ),
                        Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF2B2E83),
                          ),
                          child: Icon(
                            Icons
                                .account_balance_wallet, // Add the wallet icon here
                            color: Colors.white,
                            size: 45,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 10), // Add spacing before the additional text
                    FutureBuilder<String>(
                      future: fetchTotalCash(),
                      builder: (context, totalCashSnapshot) {
                        if (totalCashSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (totalCashSnapshot.hasError) {
                          return Text("Error: ${totalCashSnapshot.error}");
                        } else {
                          final totalCash =
                              int.tryParse(totalCashSnapshot.data ?? "0") ?? 0;

                          // Now, fetch ABS Fees
                          return FutureBuilder<String>(
                            future: fetchAbsFees(),
                            builder: (context, absFeesSnapshot) {
                              if (absFeesSnapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator();
                              } else if (absFeesSnapshot.hasError) {
                                return Text("Error: ${absFeesSnapshot.error}");
                              } else {
                                final absFees =
                                    int.tryParse(absFeesSnapshot.data ?? "0") ??
                                        0;

                                // Calculate the difference
                                final int difference =
                                    calculateDifference(totalCash, absFees);

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      difference.toString(),
                                      style: TextStyle(
                                        fontSize: 45,
                                        color: Color(0xFF2B2E83),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      'EGP',
                                      style: TextStyle(
                                        fontSize: 25,
                                        color: Color(0xFF2B2E83),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            },
                          );
                        }
                      },
                    )
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
