import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  TextEditingController _dateController = TextEditingController();
  DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  DateTime _selectedStartDate = DateTime.now();
  DateTime _selectedEndDate = DateTime.now();

  Future<void> _selectDateRange(BuildContext context) async {
    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: _selectedStartDate,
        end: _selectedEndDate,
      ),
    );

    if (selectedRange != null) {
      setState(() {
        _selectedStartDate = selectedRange.start;
        _selectedEndDate = selectedRange.end;
        _dateController.text =
            "${_dateFormat.format(_selectedStartDate)} - ${_dateFormat.format(_selectedEndDate)}";
      });
    }
  }

  Card buildInfoCard(String awb, String status, String deliveryDate,
      String paymentDate, String cash) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color:
                    Color(0xFF2B2E83), // Background color for the title 'AWB'
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
                  color: Colors.white, // Text color for the title 'AWB'
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Status: $status', style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('Cash: $cash', style: TextStyle(fontSize: 14)),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Delivery Date: $deliveryDate',
                          style: TextStyle(fontSize: 14)),
                      SizedBox(height: 8),
                      Text('Payment Date: $paymentDate',
                          style: TextStyle(fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wallet'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Container(
                  padding: const EdgeInsets.all(6),
                  child: TextField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () {
                      _selectDateRange(context);
                    },
                    decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: 'Creation Date',
                      suffixIcon: Icon(Icons.calendar_view_day),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              buildCard('Expected Cash', '15,000 EGP', Color(0xFF2B2E83)),
              buildCard('Collected Cash', '1,148 EGP', Color(0xFF2B2E83)),
              buildCard('ABS Fees + Cash Collection Fees', '48 EGP',
                  Color(0xFF2B2E83)),
              buildCard('Net Value', '199,005,900 EGP', Color(0xFF2B2E83)),
              SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *
                        0.5, // Set the width of the TextField
                    height:
                        50.0, // Set the height to match the TextField's height
                    child: TextField(
                      inputFormatters: <TextInputFormatter>[
                        LengthLimitingTextInputFormatter(
                            9), // Limit to 9 digits (ints)
                        FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9]')), // Accept only digits (ints)
                      ],
                      keyboardType: TextInputType
                          .number, // Set the keyboard type to number
                      decoration: InputDecoration(
                        fillColor: const Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: const OutlineInputBorder(),
                        labelText: 'Limit',
                      ),
                    ),
                  ),
                  SizedBox(
                      width:
                          8.0), // Add some spacing between TextField and Button
                  Container(
                    height:
                        50.0, // Set the height to match the TextField's height
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle button press here
                      },
                      child: Text('Filter'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              // Add a container for search and filter options
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
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
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 8),
                      width: 250,
                      child: TextField(
                        //controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search...',
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
                        onSubmitted: (_) {
                          // Handle search submission here if needed
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Handle search button press here if needed
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        // Handle clear button press here if needed
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              // Add a list of AWB cards here
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildInfoCard('12345', 'Delivered', '2023-09-12',
                      '2023-09-13', '1500 EGP'),
                  buildInfoCard('hbsa87', 'Undelivered', '2023-09-12',
                      '2023-09-13', '1500 EGP'),
                  buildInfoCard('12345', 'Delivered', '2022-19-09',
                      '2023-09-13', '15900 EGP'),
                  buildInfoCard('12345', 'Delivered', '2023-09-12',
                      '2023-09-13', '150900 EGP'),
                  buildInfoCard('12345', 'Delivered', '2023-09-12',
                      '2023-09-13', '1500 EGP'),
                  // Add more cards with different information here if needed
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard(String title, String amount, Color backgroundColor) {
    return Card(
      elevation: 4,
      child: Column(
        children: [
          Container(
            color: backgroundColor,
            width: double.infinity,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Text(
            amount,
            style: TextStyle(
              fontSize: 24,
              color: Color.fromARGB(255, 96, 96, 96),
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
