import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          title: Text(
            AppLocalizations.of(context)!.subAccounts,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (!isLoading && _subAccounts.isEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noSubaccounts,
                      style: const TextStyle(
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
                                    '${AppLocalizations.of(context)!.subAccountNumber}${subAccount['Sub Account Number']}'),
                                Text(
                                    '${AppLocalizations.of(context)!.pricePlanName}${subAccount['Price Plan Name']}'),
                                Text(
                                    '${AppLocalizations.of(context)!.paymentMethodType}${subAccount['Payment Method Type']}'),
                                Text(
                                    '${AppLocalizations.of(context)!.productName}${subAccount['Product Name']}'),
                                Text(
                                    '${AppLocalizations.of(context)!.prefix}${subAccount['Prefix']}'),
                                Text(
                                    '${AppLocalizations.of(context)!.creationDate}${formatDateTime(subAccount['Creation Date'])}')
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
