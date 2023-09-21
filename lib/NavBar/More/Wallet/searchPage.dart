import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> searchResults = [];
  Locale? locale;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Widget buildInfoCard(String awb, String absfees, String deliveryDate,
      String paymentDate, String cash) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(8, 8, 0, 2),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              width: double.infinity,
              child: Text(
                '${AppLocalizations.of(context)!.awb} $awb',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      '${AppLocalizations.of(context)!.cash} $cash ${AppLocalizations.of(context)!.egp}',
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      '${AppLocalizations.of(context)!.absFees} $absfees ${AppLocalizations.of(context)!.egp}',
                      style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),
            const Divider(),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                    '${AppLocalizations.of(context)!.deliveryDate} ${formatDateTime(deliveryDate)}',
                    style: const TextStyle(fontSize: 12)),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Text(
                    '${AppLocalizations.of(context)!.paymentDate} ${formatDateTime(paymentDate)}',
                    style: const TextStyle(fontSize: 12)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> searchByAWB(String awb) async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-shipments/$awb');
    final headers = AppConfig.headers;
    final response = await http.get(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = response.body;

      if (responseBody.isNotEmpty) {
        try {
          final decodedResponse =
              json.decode(responseBody) as Map<String, dynamic>;

          if (mounted) {
            setState(() {
              searchResults = [decodedResponse];
            });
          }
        } catch (e) {
          if (mounted) {
            setState(() {
              searchResults = [];
            });
          }
        }
      } else {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(AppLocalizations.of(context)!.awbNotFound),
                content: Text(
                    AppLocalizations.of(context)!.theAwbYouEnteredWasNotFound),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context)!.ok),
                  ),
                ],
              );
            },
          );
          setState(() {
            searchResults = [];
          });
        }
      }
    } else if (response.statusCode == 404) {
      if (mounted) {
        setState(() {
          searchResults = [];
        });
      }
    } else {
      throw Exception('Failed to get data from the API');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.search),
        backgroundColor: const Color.fromARGB(255, 244, 246, 248),
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Row(
            children: [
              SizedBox(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchByawb,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (awb) {
                    searchByAWB(awb);
                  },
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  searchByAWB(_searchController.text);
                },
              ),
              IconButton(
                icon: const Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    searchResults.clear();
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(5, 20, 5, 12),
        child: Center(
          child: searchResults.isNotEmpty
              ? ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (BuildContext context, int index) {
                    final result = searchResults[index];
                    return buildInfoCard(
                      locale.toString() == 'en'
                          ? result["AWB"]
                          : result["رقم الشحنة"],
                      locale.toString() == 'en'
                          ? result["ABS Fees"].toString()
                          : result["مصاريف الشحن"].toString(),
                      locale.toString() == 'en'
                          ? result["Delivery Date"]
                          : result["تاريخ التسليم"],
                      locale.toString() == 'en'
                          ? result["Payment Date"]
                          : result["تاريخ الدفع"],
                      locale.toString() == 'en'
                          ? result["Cash"].toString()
                          : result["المبلغ"].toString(),
                    );
                  },
                )
              : Text(AppLocalizations.of(context)!.noSearchResults),
        ),
      ),
    );
  }
}
