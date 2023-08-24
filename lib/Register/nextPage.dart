import 'package:flutter/material.dart';
import 'table_widget.dart';

class NextPage extends StatefulWidget {
  @override
  _NextPageState createState() => _NextPageState();
}

class _NextPageState extends State<NextPage> {
  int selectedCardIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Subscription Plans'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose a Subscription Plan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                      });
                    },
                  ),
              ],
            ),
            SizedBox(height: 16),
            if (selectedCardIndex != -1)
              Expanded(
                child: SingleChildScrollView(
                  child: TableWidget(plans[selectedCardIndex].tableData),
                ),
              ),
          ],
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
  final Color planColor;
  final String selectedText;
  final List<String> tableData;

  Plan({
    required this.title,
    required this.price,
    required this.subPriceText,
    required this.billedText,
    required this.planColor,
    required this.selectedText,
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
            color:
                isSelected ? plan.planColor.withOpacity(0.8) : plan.planColor,
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
                ),
              ),
              SizedBox(height: 2),
              Text(plan.price),
              Text(plan.subPriceText),
              Text(plan.billedText),
            ],
          ),
        ),
      ),
    );
  }
}

List<Plan> plans = [
  Plan(
    title: 'Gold Plan',
    price: '\$10',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    planColor: Color(0xFFFFD700),
    selectedText: 'Gold plan selected',
    tableData: [
      'Silver Data 1',
      'Silver Data 2',
      'Silver Data 3',
      'Silver Data 4',
      'Silver Data 5',
      'Silver Data 6',
      'Silver Data 7',
      'Silver Data 8',
      'Silver Data 9',
      'Silver Data 10',
      'Silver Data 11',
      'Silver Data 12',
      'Silver Data 13',
      'Silver Data 14',
      'Silver Data 15',
      'Silver Data 16',
      'Silver Data 17',
      'Silver Data 18',
      'Silver Data 19',
      'Silver Data 20',
      'Silver Data 21',
      'Silver Data 22',
      'Silver Data 23',
      'Silver Data 24',
      'Silver Data 25',
      'Silver Data 26',
      'Silver Data 27',
      'Silver Data 28',
      'Silver Data 29',
      'Silver Data 30',
      'Silver Data 31',
      'Silver Data 32',
      'Silver Data 33',
      'Silver Data 34',
      'Silver Data 35',
      'Silver Data 36',
      'Silver Data 37',
      'Silver Data 38',
      'Silver Data 39',
      'Silver Data 40',
      'Silver Data 41',
      'Silver Data 42',
      'Silver Data 43',
      'Silver Data 44',
      'Silver Data 45',
      'Silver Data 46',
      'Silver Data 47',
      'Silver Data 48',
      'Silver Data 49',
      'Silver Data 50',
      'Silver Data 51',
      'Silver Data 52',
      'Silver Data 53',
      'Silver Data 54',
      'Silver Data 55',
      'Silver Data 56',
      'Silver Data 57',
      'Silver Data 58',
      'Silver Data 59',
      'Silver Data 60',
      'Silver Data 61',
      'Silver Data 62',
      'Silver Data 63',
      'Silver Data 64',
    ],
  ),
  Plan(
    title: 'Silver Plan',
    price: '\$20',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    planColor: Color(0xFFC0C0C0),
    selectedText: 'Silver plan selected',
    tableData: [
      'Silver Data 1',
      'Silver Data 2',
      'Silver Data 3',
      'Silver Data 4',
      'Silver Data 5',
      'Silver Data 6',
      'Silver Data 7',
      'Silver Data 8',
      'Silver Data 9',
      'Silver Data 10',
      'Silver Data 11',
      'Silver Data 12',
      'Silver Data 13',
      'Silver Data 14',
      'Silver Data 15',
      'Silver Data 16',
      'Silver Data 17',
      'Silver Data 18',
      'Silver Data 19',
      'Silver Data 20',
      'Silver Data 21',
      'Silver Data 22',
      'Silver Data 23',
      'Silver Data 24',
      'Silver Data 25',
      'Silver Data 26',
      'Silver Data 27',
      'Silver Data 28',
      'Silver Data 29',
      'Silver Data 30',
      'Silver Data 31',
      'Silver Data 32',
      'Silver Data 33',
      'Silver Data 34',
      'Silver Data 35',
      'Silver Data 36',
      'Silver Data 37',
      'Silver Data 38',
      'Silver Data 39',
      'Silver Data 40',
      'Silver Data 41',
      'Silver Data 42',
      'Silver Data 43',
      'Silver Data 44',
      'Silver Data 45',
      'Silver Data 46',
      'Silver Data 47',
      'Silver Data 48',
      'Silver Data 49',
      'Silver Data 50',
      'Silver Data 51',
      'Silver Data 52',
      'Silver Data 53',
      'Silver Data 54',
      'Silver Data 55',
      'Silver Data 56',
      'Silver Data 57',
      'Silver Data 58',
      'Silver Data 59',
      'Silver Data 60',
      'Silver Data 61',
      'Silver Data 62',
      'Silver Data 63',
      'Silver Data 64',
    ],
  ),
  Plan(
    title: 'Bronze Plan',
    price: '\$30',
    subPriceText: 'per month',
    billedText: 'Billed monthly',
    planColor: Color(0xFFCD7F32),
    selectedText: 'Bronze plan selected',
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
