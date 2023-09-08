import 'package:flutter/material.dart';
import 'table_widget.dart';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Plan {
  final String title;
  final String price;
  final List<Map<String, dynamic>> tableData;

  Plan({
    required this.title,
    required this.price,
    required this.tableData,
  });
}

class AnimatedPlanCard extends StatelessWidget {
  final Plan plan;
  final bool isSelected;
  final VoidCallback onSelect;

  AnimatedPlanCard({
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
            color: isSelected ? Color(0xFF2B2E83) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? Color(0xFF2B2E83) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
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
              SizedBox(height: 2),
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
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int selectedCardIndex = -1;
  int selectedNewCardIndex = -1;
  List<Plan> guestPlans = [];
  List<Plan> plans = []; // Define plans here
  @override
  void initState() {
    super.initState();
    fetchPlansFromApi();
  }

  Future<void> fetchPlansFromApi() async {
    try {
      final response = await http
          .get(Uri.parse('http://192.168.137.166:3000/price-plan-names/1'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        if (jsonData != null) {
          plans.clear();
          guestPlans.clear();

          for (var apiPlan in jsonData) {
            final title = apiPlan['Price Plan Name'];
            final price =
                ' ${apiPlan['Number Of Shipments'] ?? 0} Shipments / Month';

            final parsedTableData = [
              {
                "#": "Zone1",
                "Zone": apiPlan['Zone1'],
              },
              {
                "#": "Zone2",
                "Zone": apiPlan['Zone2'],
              },
              {
                "#": "Zone3",
                "Zone": apiPlan['Zone3'],
              },
              {
                "#": "Zone4",
                "Zone": apiPlan['Zone4'],
              },
              {
                "#": "Zone5",
                "Zone": apiPlan['Zone5'],
              },
              {
                "#": "Zone6",
                "Zone": apiPlan['Zone6'],
              },
              {
                "#": "Zone7",
                "Zone": apiPlan['Zone7'],
              },
              {
                "#": "Zone8",
                "Zone": apiPlan['Zone8'],
              },
            ];

            final plan = Plan(
              title: title ?? '',
              price: price,
              tableData: parsedTableData,
            );

            plans.add(plan);

            if (title == 'Basic') {
              guestPlans.add(plan);
            }
          }

          setState(() {
            // Update the UI after fetching and processing the data
            this.guestPlans = guestPlans;
            this.plans = plans;
          });
        }
      } else {
        print('Failed to fetch plans from the API.');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Subscription Plans'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              Text(
                'Choose a Subscription Plan',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'Business Plan', // Add this text
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (int i = 0; i < plans.length; i++)
                    if (plans[i].title != 'Basic')
                      AnimatedPlanCard(
                        plan: plans[i],
                        isSelected: selectedCardIndex == i,
                        onSelect: () {
                          setState(() {
                            if (selectedCardIndex == i) {
                              selectedCardIndex =
                                  -1; // Deselect if already selected
                            } else {
                              selectedCardIndex = i; // Select if not selected
                              selectedNewCardIndex =
                                  -1; // Deselect any new card
                            }
                          });
                        },
                      ),
                ],
              ),
              if (selectedCardIndex != -1)
                Container(
                  height:
                      9 * 56.0 + 56.0, // Total height of 9 rows + header row
                  child: SingleChildScrollView(
                    child: TableWidget(plans[selectedCardIndex].tableData),
                  ),
                ),
              SizedBox(height: 32), // Add some space between sections
              Text(
                'Guest Plan', // Add this text
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
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
                          setState(() {
                            selectedNewCardIndex = i;
                            selectedCardIndex = -1; // Deselect any main card
                          });
                        },
                      ),
                ],
              ),
              if (selectedNewCardIndex != -1)
                Container(
                  height:
                      9 * 56.0 + 56.0, // Total height of 9 rows + header row
                  child: SingleChildScrollView(
                    child: TableWidget(plans[selectedNewCardIndex].tableData),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

List<Plan> newPlans = [];

List<Plan> plans = [];
