import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      if (mounted) {
        setState(() {
          _selectedStartDate = selectedRange.start;
          _selectedEndDate = selectedRange.end;
          _dateController.text =
              "${_dateFormat.format(_selectedStartDate)} - ${_dateFormat.format(_selectedEndDate)}";
        });
      }
    }
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
