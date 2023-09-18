// ignore_for_file: empty_catches, use_build_context_synchronously, library_private_types_in_public_api

import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:abs_mobile_app/Register/table_widget.dart';
import 'package:abs_mobile_app/Register/user_data.dart';
import 'package:abs_mobile_app/Register/zoneDetails.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../Configurations/app_config.dart';

class Plan {
  final String title;
  final int pricePlanId;
  final String price;
  final List<Map<String, dynamic>> tableData;

  Plan({
    required this.title,
    required this.pricePlanId,
    required this.price,
    required this.tableData,
  });
}

class AnimatedPlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  const AnimatedPlanCard({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final scaleFactor = isSelected ? 1.05 : 0.95;

    return GestureDetector(
      onTap: onSelect,
      child: Transform.scale(
        scale: scaleFactor,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.3,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF2B2E83) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF2B2E83) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                plan.title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              Text(
                "Plan",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                plan.price,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatefulWidget {
  final UserData userData;

  const NextPage({super.key, required this.userData});

  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int selectedCardIndex = -1;
  int selectedNewCardIndex = -1;
  List<Plan> guestPlans = [];
  List<Plan> plans = [];

  int? clientTypeID;

  int? selectedPricePlanId;

  @override
  void initState() {
    super.initState();
    fetchPlansFromApi();
  }

  Future<void> register() async {
    final url = Uri.parse('${AppConfig.baseUrl}/register');
    final requestBody = {
      'firstName': widget.userData.fullName.split(' ')[0],
      'lastName': widget.userData.fullName.split(' ')[1],
      'email': widget.userData.email,
      'contactNumber': widget.userData.phoneNumber,
      'username': widget.userData.userName,
      'password': widget.userData.password,
      'pricePlanID': selectedPricePlanId,
      'clientTypeID': clientTypeID,
    };
    final jsonBody = json.encode(requestBody);
    final response =
        await http.post(url, headers: AppConfig.headers, body: jsonBody);
    if (response.statusCode == 200) {
      final url = Uri.parse('${AppConfig.baseUrl}/signin-client');
      final requestBody = {
        "userCred": widget.userData.userName,
        "password": widget.userData.password
      };

      final jsonBody = json.encode(requestBody);

      final headers = {
        'Content-Type': 'application/json',
      };
      final response = await http.post(
        url,
        headers: headers,
        body: jsonBody,
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        final accessToken = responseBody["accessToken"];
        await AppConfig.storeToken(accessToken);
        await AppConfig.initialize();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavBar()),
        );
      } else {
        // Failed login
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Something went wrong, try again later.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchPlansFromApi() async {
    try {
      final response =
          await http.get(Uri.parse('${AppConfig.baseUrl}/price-plan-names/1'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        plans.clear();
        guestPlans.clear();

        for (var apiPlan in jsonData) {
          final pricePlanId = apiPlan['Price Plan ID'];
          final title = apiPlan['Price Plan Name'];
          final price =
              ' ${apiPlan['Number Of Shipments'] ?? 0} Shipments / Month';
          final response = await http.get(Uri.parse(
              '${AppConfig.baseUrl}/price-plans-matrix-by-ID/$pricePlanId'));

          final parsedTableData = <Map<String, dynamic>>[];

          if (response.statusCode == 200) {
            final jsonData = json.decode(response.body) as List<dynamic>;
            if (jsonData != null) {
              for (var apiRow in jsonData) {
                final row = <String, dynamic>{};
                for (var key in apiRow.keys) {
                  row[key] = apiRow[key];
                }
                parsedTableData.add(row);
              }
            }
          }
          final plan = Plan(
            title: title ?? '',
            pricePlanId: pricePlanId ?? '',
            price: price,
            tableData: parsedTableData,
          );

          plans.add(plan);

          if (title == 'Basic') {
            guestPlans.add(plan);
          }
        }
        if (mounted) {
          setState(() {
            guestPlans = guestPlans;
            plans = plans;
          });
        }
      } else {}
    } catch (error) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          title: const Text(
            'Subscription Plans',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 244, 246, 248),
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    const Text(
                      'Choose a Subscription Plan',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Business Plan', // Add this text
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < plans.length; i++)
                          if (plans[i].title != 'Basic')
                            AnimatedPlanCard(
                              plan: plans[i],
                              isSelected: selectedCardIndex == i,
                              onSelect: () {
                                if (mounted) {
                                  setState(() {
                                    if (selectedCardIndex == i) {
                                      selectedCardIndex =
                                          -1; // Deselect if already selected
                                      setState(() {
                                        selectedPricePlanId = null;
                                      });
                                    } else {
                                      selectedCardIndex =
                                          i; // Select if not selected
                                      setState(() {
                                        selectedPricePlanId =
                                            plans[i].pricePlanId;
                                      });

                                      setState(() {
                                        clientTypeID = 2;
                                      });
                                      selectedNewCardIndex =
                                          -1; // Deselect any new card
                                    }
                                  });
                                }
                              },
                            ),
                      ],
                    ),
                    if (selectedCardIndex != -1)
                      SizedBox(
                        height: 9 * 56.0 +
                            56.0, // Total height of 9 rows + header row
                        child: SingleChildScrollView(
                          child:
                              TableWidget(plans[selectedCardIndex].tableData),
                        ),
                      ),
                    const SizedBox(
                        height: 32), // Add some space between sections
                    const Text(
                      'Guest Plan', // Add this text
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < plans.length; i++)
                          if (plans[i].title ==
                              'Basic') // Display only Basic in Guest plans
                            AnimatedPlanCard(
                              plan: plans[i],
                              isSelected: selectedNewCardIndex == i,
                              onSelect: () {
                                if (mounted) {
                                  setState(() {
                                    if (selectedNewCardIndex == i) {
                                      selectedNewCardIndex =
                                          -1; // Deselect if already selected
                                      setState(() {
                                        selectedPricePlanId = null;
                                      });
                                    } else {
                                      selectedNewCardIndex =
                                          i; // Select if not selected
                                      setState(() {
                                        selectedPricePlanId =
                                            plans[i].pricePlanId;
                                      });

                                      setState(() {
                                        clientTypeID = 3;
                                      });
                                      selectedCardIndex =
                                          -1; // Deselect any new card
                                    }
                                  });
                                }
                              },
                            ),
                      ],
                    ),
                    if (selectedNewCardIndex != -1)
                      SizedBox(
                        height: 9 * 56.0 +
                            56.0, // Total height of 9 rows + header row
                        child: SingleChildScrollView(
                          child: TableWidget(
                              plans[selectedNewCardIndex].tableData),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(
                            milliseconds: 300), // Adjust the animation duration
                        pageBuilder: (_, __, ___) => ZoneDetailsPage(),
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
                  child: const Text('View Zones Details'),
                ),
              ),
              Container(
                width: double.infinity,
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: ElevatedButton(
                  onPressed: selectedPricePlanId != null
                      ? () {
                          register();
                        }
                      : null,
                  child: const Text('Register'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
