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

  bool isEmailVerified = true; // Replace with your actual logic
  bool isCompanyInfoComplete = false; // Replace with your actual logic
  bool isCompanyAddressComplete = true; // Replace with your actual l
  String NewOrders = '1890';
  String ProcessingwOrders = '17987';
  String InTransit = '28946';
  String OutForDelivery = '86949';
  String ReturningToOrigin = '89742';
  String AwaitingYourAction = '95930';
  String OnHold = '49590';
  String YourBalance = '140978';

  int getValidatedConditionsCount() {
    int count = 0;
    if (isEmailVerified) count++;
    if (isCompanyInfoComplete) count++;
    if (isCompanyAddressComplete) count++;
    return count;
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
          additionalInfo, // Use the provided additional info for each status text
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusCircle(int count) {
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
              value: count / 3,
              strokeWidth: 10,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2B2E83)),
              backgroundColor: Color.fromARGB(255, 214, 214, 214),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  color: Color(0xFF2B2E83),
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text(
                'of 3',
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int validatedConditionsCount = getValidatedConditionsCount();
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
            Row(
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
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 8),
                              Text(
                                'Complete your' +
                                    '\n' 'account for' '\n' 'a full experience',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(249, 0, 0, 0),
                                ),
                              ),
                              SizedBox(width: 70),
                              _buildStatusCircle(validatedConditionsCount),
                            ],
                          ),
                          SizedBox(height: 40),
                          _buildStatusRow(
                              'Email Verification', isEmailVerified),
                          _buildDivider(),
                          _buildStatusRow(
                              'Company Info', isCompanyInfoComplete),
                          _buildDivider(),
                          _buildStatusRow(
                              'Company Address', isCompanyAddressComplete),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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
                    Text(
                      'Orders Overview', // Add the title here
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
                                SizedBox(height: 8),
                                Text(
                                  'New Orders',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(248, 125, 125, 125),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: Text(
                                NewOrders, // Replace with the appropriate number
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(248, 79, 79, 79),
                                ),
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
                                SizedBox(height: 8),
                                Text(
                                  'Processing Orders',
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(248, 125, 125, 125),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: 0,
                              left: 8,
                              child: Text(
                                ProcessingwOrders, // Replace with the appropriate number
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color.fromARGB(248, 79, 79, 79),
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
                    Text(
                      'Processing Orders', // Add the title here
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(249, 0, 0, 0),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ), // Add spacing before the additional text
                    Text(
                      'Status for all orders under processing', // Add your text here
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildStatusText('In transit', InTransit),
                    SizedBox(height: 20),
                    _buildStatusText('Out for delivery', OutForDelivery),
                    SizedBox(height: 20),
                    _buildStatusText('Returning to origin', ReturningToOrigin),
                    SizedBox(height: 20),
                    _buildStatusText(
                        'Awaiting your action', AwaitingYourAction),
                    SizedBox(height: 20),
                    _buildStatusText('On hold', OnHold),
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
                      height: 5,
                    ), // Add spacing before the additional text
                    Text(
                      YourBalance, // Add your text here
                      style: TextStyle(
                        fontSize: 45,
                        color: Color(0xFF2B2E83),
                      ),
                    ),

                    SizedBox(
                        height: 5), // Add spacing before the additional text
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
