import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class SubAccountsPage extends StatefulWidget {
  @override
  _SubAccountsPageState createState() => _SubAccountsPageState();
}

class _SubAccountsPageState extends State<SubAccountsPage> {
  bool isLoading = true;
  List<dynamic> _subAccounts = [];

  @override
  void initState() {
    super.initState();
    getSubAccounts();
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Future<void> getSubAccounts() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/sub-accounts-by-main-account-ID/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _subAccounts = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _subAccounts = [];
            isLoading = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Sub Accounts',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (!isLoading && _subAccounts.isEmpty)
                  const Center(
                    child: Text(
                      'No Subaccounts',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // Customize the color
                      ),
                    ),
                  ),
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _subAccounts.map((subAccount) {
                      return Card(
                        color: const Color.fromARGB(255, 229, 229, 229),
                        elevation: 4, // Adjust the elevation as needed
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8), // Adjust margins
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(12), // Add rounded corners
                        ),

                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(
                                      '${subAccount['Sub Account Name']}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20))),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    'Sub Account Number: ${subAccount['Sub Account Number']}'),
                                Text(
                                    'Price Plan Name: ${subAccount['Price Plan Name']}'),
                                Text(
                                    'Payment Method Type: ${subAccount['Payment Method Type']}'),
                                Text(
                                    'Product Name: ${subAccount['Product Name']}'),
                                Text('Prefix: ${subAccount['Prefix']}'),
                                Text(
                                    'Creation Date: ${formatDateTime(subAccount['Creation Date'])}')
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
