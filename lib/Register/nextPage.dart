import 'package:flutter/material.dart';
import 'table_widget.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int selectedCardIndex = -1;
  int selectedNewCardIndex = -1;

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
                    AnimatedPlanCard(
                      plan: plans[i],
                      isSelected: selectedCardIndex == i,
                      onSelect: () {
                        setState(() {
                          selectedCardIndex = i;
                          selectedNewCardIndex = -1; // Deselect any new card
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
                  for (int i = 0; i < newPlans.length; i++)
                    AnimatedPlanCard(
                      plan: newPlans[i],
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
                    child:
                        TableWidget(newPlans[selectedNewCardIndex].tableData),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class Plan {
  final String title;
  final String price;
  final String subPriceText;
  final String billedText;
  final List<String> tableData;

  Plan({
    required this.title,
    required this.price,
    required this.subPriceText,
    required this.billedText,
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
              SizedBox(height: 2),
              Text(
                plan.price,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
              Text(
                plan.subPriceText,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
              Text(
                plan.billedText,
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

List<Plan> newPlans = [
  Plan(
    title: 'New Plan 1',
    price: '\$15',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    tableData: [
      'GD2 1',
      'GD2 2',
      'GD2 3',
      'GD2 4',
      'GD2 5',
      'GD2 6',
      'GD2 7',
      'GD2 8',
      'GD2 9',
      'GD2 10',
      'GD2 11',
      'GD2 12',
      'GD2 13',
      'GD2 14',
      'GD2 15',
      'GD2 16',
      'GD2 17',
      'GD2 18',
      'GD2 19',
      'GD2 20',
      'GD2 21',
      'GD2 22',
      'GD2 23',
      'GD2 24',
      'GD2 25',
      'GD2 26',
      'GD2 27',
      'GD2 28',
      'GD2 29',
      'GD2 30',
      'GD2 31',
      'GD2 32',
      'GD2 33',
      'GD2 34',
      'GD2 35',
      'GD2 36',
      'GD2 37',
      'GD2 38',
      'GD2 39',
      'GD2 40',
      'GD2 41',
      'GD2 42',
      'GD2 43',
      'GD2 44',
      'GD2 45',
      'GD2 46',
      'GD2 47',
      'GD2 48',
      'GD2 49',
      'GD2 50',
      'GD2 51',
      'GD2 52',
      'GD2 53',
      'GD2 54',
      'GD2 55',
      'GD2 56',
      'GD2 57',
      'GD2 58',
      'GD2 59',
      'GD2 60',
      'GD2 61',
      'GD2 62',
      'GD2 63',
      'GD2 64',
    ],
  ),
];

List<Plan> plans = [
  Plan(
    title: 'Gold Plan',
    price: '\$10',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    tableData: [
      'GD 1',
      'GD 2',
      'GD 3',
      'GD 4',
      'GD 5',
      'GD 6',
      'GD 7',
      'GD 8',
      'GD 9',
      'GD 10',
      'GD 11',
      'GD 12',
      'GD 13',
      'GD 14',
      'GD 15',
      'GD 16',
      'GD 17',
      'GD 18',
      'GD 19',
      'GD 20',
      'GD 21',
      'GD 22',
      'GD 23',
      'GD 24',
      'GD 25',
      'GD 26',
      'GD 27',
      'GD 28',
      'GD 29',
      'GD 30',
      'GD 31',
      'GD 32',
      'GD 33',
      'GD 34',
      'GD 35',
      'GD 36',
      'GD 37',
      'GD 38',
      'GD 39',
      'GD 40',
      'GD 41',
      'GD 42',
      'GD 43',
      'GD 44',
      'GD 45',
      'GD 46',
      'GD 47',
      'GD 48',
      'GD 49',
      'GD 50',
      'GD 51',
      'GD 52',
      'GD 53',
      'GD 54',
      'GD 55',
      'GD 56',
      'GD 57',
      'GD 58',
      'GD 59',
      'GD 60',
      'GD 61',
      'GD 62',
      'GD 63',
      'GD 64',
    ],
  ),
  Plan(
    title: 'Silver Plan',
    price: '\$10',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    tableData: [
      'SD 1',
      'SD 2',
      'SD 3',
      'SD 4',
      'SD 5',
      'SD 6',
      'SD 7',
      'SD 8',
      'SD 9',
      'SD 10',
      'SD 11',
      'SD 12',
      'SD 13',
      'SD 14',
      'SD 15',
      'SD 16',
      'SD 17',
      'SD 18',
      'SD 19',
      'SD 20',
      'SD 21',
      'SD 22',
      'SD 23',
      'SD 24',
      'SD 25',
      'SD 26',
      'SD 27',
      'SD 28',
      'SD 29',
      'SD 30',
      'SD 31',
      'SD 32',
      'SD 33',
      'SD 34',
      'SD 35',
      'SD 36',
      'SD 37',
      'SD 38',
      'SD 39',
      'SD 40',
      'SD 41',
      'SD 42',
      'SD 43',
      'SD 44',
      'SD 45',
      'SD 46',
      'SD 47',
      'SD 48',
      'SD 49',
      'SD 50',
      'SD 51',
      'SD 52',
      'SD 53',
      'SD 54',
      'SD 55',
      'SD 56',
      'SD 57',
      'SD 58',
      'SD 59',
      'SD 60',
      'SD 61',
      'SD 62',
      'SD 63',
      'SD 64',
    ],
  ),
  Plan(
    title: 'Bronze Plan',
    price: '\$10',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    tableData: [
      'Zone 1',
      'Zone 2',
      'Zone 3',
      'Zone 4',
      'Zone 5',
      'Zone 6',
      'Zone 7',
      'Zone 8',
      'Zone 9',
      'Zone 10',
      'Zone 11',
      'Zone 12',
      'Zone 13',
      'Zone 14',
      'Zone 15',
      'Zone 16',
      'Zone 17',
      'Zone 18',
      'Zone 19',
      'Zone 20',
      'Zone 21',
      'Zone 22',
      'Zone 23',
      'Zone 24',
      'Zone 25',
      'Zone 26',
      'Zone 27',
      'Zone 28',
      'Zone 29',
      'Zone 30',
      'Zone 31',
      'Zone 32',
      'Zone 33',
      'Zone 34',
      'Zone 35',
      'Zone 36',
      'Zone 37',
      'Zone 38',
      'Zone 39',
      'Zone 40',
      'Zone 41',
      'Zone 42',
      'Zone 43',
      'Zone 44',
      'Zone 45',
      'Zone 46',
      'Zone 47',
      'Zone 48',
      'Zone 49',
      'Zone 50',
      'Zone 51',
      'Zone 52',
      'Zone 53',
      'Zone 54',
      'Zone 55',
      'Zone 56',
      'Zone 57',
      'Zone 58',
      'Zone 59',
      'Zone 60',
      'Zone 61',
      'Zone 62',
      'Zone 63',
      'Zone 64',
    ],
  ),
];
