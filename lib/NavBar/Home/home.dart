// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:abs_mobile_app/NavBar/More/Settings/BusinessLocations/businessLocations.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'dart:convert';
import 'package:abs_mobile_app/NavBar/More/Settings/BusinessInfo/businessInfo.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/paymentMethods.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
  const HomePage({Key? key}) : super(key: key);
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<_HomePageState> homePageKey = GlobalKey<_HomePageState>();
  bool _isLoading = true;
  bool emailVerificationClicked = false;
  DateTime? emailVerificationTime;

  String? userName;
  String? email;
  List<dynamic> validationData = [];
  int totalConditionsCount = 0;
  int validatedConditionsCount = 0;
  bool isRowVisible = true;

  int inTransitCount = 0;
  int outForDeliveryCount = 0;
  int outForReturnCount = 0;
  int onHoldCount = 0;
  int deliveredCount = 0;
  int undeliveredCount = 0;
  int returnedToShipperCount = 0;

  int newShipmentsCount = 0;
  int processingShipmentsCount = 0;

  int totalCash = 0;
  int absFees = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      await Future.wait([
        getUserData(),
        getValidations(),
        getShipmentsCount(),
        getTotalCash(),
        getAbsFees(),
      ]);
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> getUserData() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users-with-info-client');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (mounted) {
        setState(() {
          userName = responseBody[0]['firstName'];
          email = responseBody[0]['email'];
        });
      }
    } else {
      throw Exception('Failed to get user info');
    }
  }

  Future<void> getValidations() async {
    final url = Uri.parse(
        '${AppConfig.baseUrl}/subAccounts-verification-by-subAccountId');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;

      for (final data in responseBody) {
        if (mounted) {
          setState(() {
            validationData.add(data);
            if (data["isVerified"]) {
              validatedConditionsCount++;
            }
          });
        }
      }
      if (mounted) {
        setState(() {
          totalConditionsCount = validationData.length;
          if (totalConditionsCount == validatedConditionsCount) {
            isRowVisible = false;
          }
        });
      }
    } else {
      throw Exception('Failed to get user validations');
    }
  }

  Widget _buildStatusRow(BuildContext context, String title, bool isVerified) {
    void navigateToPage(String title) async {
      switch (title) {
        case 'Add your pickup location':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BusinessLocationsPage()),
          );
          break;
        case 'Add your payment method':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PaymentMethodsPage()),
          );
          break;
        case 'Add your business info':
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BusinessInfoPage()),
          );
          break;
        case 'Verify your email address':
          if (!isVerified && !emailVerificationClicked) {
            final url = Uri.parse(
                '${AppConfig.baseUrl}/subAccounts-verification/send-email');

            final requestBody = {'email': email};

            final jsonBody = json.encode(requestBody);
            final response = await http.post(url,
                headers: AppConfig.headers, body: jsonBody);
            if (response.statusCode == 200) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Email sent to $email',
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Failed to send email to $email',
                  ),
                ),
              );
            }
            if (mounted) {
              setState(() {
                emailVerificationClicked = true;
                emailVerificationTime = DateTime.now();
              });
            }
          } else if (emailVerificationClicked) {
            final currentTime = DateTime.now();
            if (emailVerificationTime != null &&
                currentTime.difference(emailVerificationTime!) >
                    const Duration(minutes: 2)) {
              if (mounted) {
                setState(() {
                  emailVerificationClicked = false;
                  emailVerificationTime = null;
                });
              }
            } else {
              final timeRemainingInSeconds = (2 * 60) -
                  currentTime.difference(emailVerificationTime!).inSeconds;
              final minutes = (timeRemainingInSeconds / 60).floor();
              final seconds = timeRemainingInSeconds % 60;

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Email verification disabled for $minutes min $seconds sec.',
                  ),
                ),
              );
            }
          }
          break;
        default:
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unknown title: $title'),
            ),
          );
      }
    }

    return GestureDetector(
      onTap: () {
        navigateToPage(title);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: const Color.fromARGB(255, 114, 114, 114),
              decoration: isVerified ? TextDecoration.lineThrough : null,
            ),
          ),
          Container(
            width: 30,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isVerified ? Colors.grey : const Color(0xFF2B2E83),
            ),
            child: Icon(
              isVerified ? Icons.check : Icons.keyboard_double_arrow_right,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCircle(int validatedCount, int totalCount) {
    double progress = totalCount > 0 ? validatedCount / totalCount : 0.0;
    String progressText = '$validatedCount';
    String progressText2 = 'of $totalCount';

    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 74,
            height: 74,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF2B2E83)),
              backgroundColor: const Color.fromARGB(255, 214, 214, 214),
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

  Future<void> getShipmentsCount() async {
    try {
      final url =
          Uri.parse('${AppConfig.baseUrl}/status-count-by-subAccountID');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body) as List<dynamic>;
        if (responseBody.isNotEmpty) {
          for (final statusData in responseBody) {
            String status = statusData['Status'];
            int count = statusData['Count'];
            if (mounted) {
              setState(() {
                if (status == 'New') {
                  newShipmentsCount = count;
                } else if (status == 'In Transit') {
                  inTransitCount = count;
                } else if (status == 'Out For Delivery') {
                  outForDeliveryCount = count;
                } else if (status == 'Out for return') {
                  outForReturnCount = count;
                } else if (status == 'On hold') {
                  onHoldCount = count;
                } else if (status == 'Delivered') {
                  deliveredCount = count;
                } else if (status == 'Undelivered') {
                  undeliveredCount = count;
                } else if (status == 'Returned To Shipper') {
                  returnedToShipperCount = count;
                }

                if (status != 'Delivered' &&
                    status != 'New' &&
                    status != 'Returned To Shipper' &&
                    status != 'Undelivered') {
                  processingShipmentsCount += int.parse(count.toString());
                }
              });
            }
          }
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> getTotalCash() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/wallet-paid-cash');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody.isNotEmpty) {
          if (mounted) {
            setState(() {
              totalCash = int.parse(responseBody[0]['Total Cash'].toString());
            });
          }
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> getAbsFees() async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}/wallet-ABS-Fees');
      final response = await http.post(url, headers: AppConfig.headers);

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody.isNotEmpty) {
          if (mounted) {
            setState(() {
              absFees = int.parse(responseBody[0]['ABS Fees'].toString());
            });
          }
        }
      } else {
        throw Exception('HTTP Error: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      body: Container(
        color: const Color.fromARGB(255, 237, 237, 237),
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 180,
                        height: 150,
                      ),
                    ),
                  ),
                  if (!_isLoading)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 3, 16, 16),
                          child: Row(
                            children: [
                              Text(
                                'Hello, $userName', // Replace with the actual user name
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Text('👋', style: TextStyle(fontSize: 24)),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: isRowVisible,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Complete your'
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
                                      _buildStatusCircle(
                                          validatedConditionsCount,
                                          totalConditionsCount),
                                    ],
                                  ),
                                  Column(
                                    children: validationData.map((data) {
                                      final verificationType =
                                          data['Verification Type'] as String;
                                      final isVerified =
                                          data['isVerified'] as bool;
                                      return Builder(
                                        builder: (context) {
                                          return _buildStatusRow(context,
                                              verificationType, isVerified);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
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
                                  'Shipments Overview',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(249, 0, 0, 0),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              width: 4,
                                              height: 50,
                                              color: const Color(0xFF2B2E83),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              'New Shipments',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    248, 125, 125, 125),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 8,
                                          child: Text(
                                            newShipmentsCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 30,
                                              color: Color.fromARGB(
                                                  248, 79, 79, 79),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                                color: Color.fromARGB(
                                                    248, 125, 125, 125),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          top: 0,
                                          left: 8,
                                          child: Text(
                                            processingShipmentsCount.toString(),
                                            style: const TextStyle(
                                              fontSize: 30,
                                              color: Color.fromARGB(
                                                  248, 79, 79, 79),
                                            ),
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
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
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
                                    'Processing Shipments',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(249, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Status for all Shipments under processing',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "In Transit",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        inTransitCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Out for Delivery",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        outForDeliveryCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Out for Return",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        outForReturnCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "On Hold",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        onHoldCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
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
                                    'Processed Shipments',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(249, 0, 0, 0),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Text(
                                    'Status for all processed Shipments',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Delivered",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        deliveredCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Undelivered",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        undeliveredCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        "Returned To Shipper",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 75, 75, 75),
                                        ),
                                      ),
                                      Text(
                                        returnedToShipperCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Container(
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
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 16),
                                        child: Text(
                                          'Your Balance',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(249, 0, 0, 0),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            ((totalCash - absFees)
                                                .toString()), // Replace with your balance calculation
                                            style: const TextStyle(
                                              fontSize: 45,
                                              color: Color(0xFF2B2E83),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'EGP',
                                              style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF2B2E83),
                                    ),
                                    child: const Icon(
                                      Icons.account_balance_wallet,
                                      color: Colors.white,
                                      size: 45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ),
            Visibility(
              visible: _isLoading,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
