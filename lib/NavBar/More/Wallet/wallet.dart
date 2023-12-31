import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:abs_mobile_app/NavBar/More/Wallet/searchPage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WalletPage extends StatefulWidget {
  @override
  _WalletPageState createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  Locale? locale;

  @override
  void initState() {
    super.initState();
    getExpectedCash();
    getPaidCash(_selectedStartDate, _selectedEndDate);
    getABSFees(_selectedStartDate, _selectedEndDate);
    getPaidShipments(_selectedStartDate, _selectedEndDate);
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  int collectedCash = 0;
  int ABSFees = 0;
  int expectedCash = 0;
  List<dynamic> paidShipments = [];
  int lastIndexDisplayed = 0;

  int limit = 5;

  bool isClicked = false;

  Future<void> _selectDateRange(BuildContext context) async {
    DateTime? initialStartDate = _selectedStartDate ?? DateTime.now();
    DateTime? initialEndDate = _selectedEndDate ?? DateTime.now();

    DateTimeRange? selectedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(
        start: initialStartDate,
        end: initialEndDate,
      ),
    );

    if (selectedRange != null) {
      if (mounted) {
        setState(() {
          _selectedStartDate = selectedRange.start;
          _selectedEndDate = selectedRange.end;

          String startDateText = _selectedStartDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedStartDate!)
              : '';

          String endDateText = _selectedEndDate != null
              ? DateFormat('yyyy-MM-dd').format(_selectedEndDate!)
              : '';

          if (startDateText.isNotEmpty && endDateText.isNotEmpty) {
            _dateController.text = "$startDateText - $endDateText";
          } else if (startDateText.isNotEmpty) {
            _dateController.text = startDateText;
          } else if (endDateText.isNotEmpty) {
            _dateController.text = endDateText;
          }

          updateCollectedCash();
        });
      }
    }
  }

  Future<void> getPaidCash(DateTime? fromDate, DateTime? toDate) async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-paid-cash');
    final headers = AppConfig.headers;
    final body = json.encode({
      "fromDate": fromDate?.toString(),
      "toDate": toDate?.toString(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;

      if (responseBody.isNotEmpty) {
        final firstItem = responseBody.first;
        if (firstItem.containsKey("Total Cash")) {
          final collectedCash = firstItem["Total Cash"] as int;

          if (mounted) {
            setState(() {
              this.collectedCash = collectedCash;
            });
          }
        }
      }
    } else {
      throw Exception('Failed to get data from the API');
    }
  }

  Future<void> getABSFees(DateTime? fromDate, DateTime? toDate) async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-ABS-Fees');
    final headers = AppConfig.headers;
    final body = json.encode({
      "fromDate": fromDate?.toString(),
      "toDate": toDate?.toString(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;

      if (responseBody.isNotEmpty) {
        final firstItem = responseBody.first;
        if (firstItem.containsKey("ABS Fees")) {
          final ABSFees = firstItem["ABS Fees"] as int;

          if (mounted) {
            setState(() {
              this.ABSFees = ABSFees;
            });
          }
        }
      }
    } else {
      throw Exception('Failed to get data from the API');
    }
  }

  Future<void> getExpectedCash() async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-expected-cash');
    final headers = AppConfig.headers;

    final response = await http.post(url, headers: headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;

      if (responseBody.isNotEmpty) {
        final firstItem = responseBody.first;
        if (firstItem.containsKey("Total Cash")) {
          final expectedCash = firstItem["Total Cash"] as int;

          if (mounted) {
            setState(() {
              this.expectedCash = expectedCash;
            });
          }
        }
      }
    } else {
      throw Exception('Failed to get data from the API');
    }
  }

  Future<void> getPaidShipments(DateTime? fromDate, DateTime? toDate) async {
    final url = Uri.parse('${AppConfig.baseUrl}/wallet-shipments/$limit');
    final headers = AppConfig.headers;
    final body = json.encode({
      "fromDate": fromDate?.toString(),
      "toDate": toDate?.toString(),
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body) as List<dynamic>;

      if (responseBody.isNotEmpty) {
        if (mounted) {
          setState(() {
            paidShipments = responseBody;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            paidShipments = [];
          });
        }
      }
    } else {
      throw Exception('Failed to get data from the API');
    }
  }

  Future<void> updateCollectedCash() async {
    if (_selectedStartDate != null && _selectedEndDate != null) {
      await getPaidCash(_selectedStartDate, _selectedEndDate);
      await getABSFees(_selectedStartDate, _selectedEndDate);

      await getPaidShipments(_selectedStartDate, _selectedEndDate);
    }
  }

  String formatDateTime(String dateTimeString) {
    final dateTime = DateTime.parse(dateTimeString).toLocal();
    final formatter = DateFormat('dd-MM-yyyy h:mm a');
    return formatter.format(dateTime);
  }

  Card buildInfoCard(String awb, String absfees, String deliveryDate,
      String paymentDate, String cash) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 235, 235, 235),
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
                color: Color.fromARGB(255, 235, 235, 235),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
              ),
              width: double.infinity,
              child: Text(
                '${AppLocalizations.of(context)!.awb} ${awb}',
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
                      '${AppLocalizations.of(context)!.cash} ${cash!} ${AppLocalizations.of(context)!.egp}',
                      style: const TextStyle(fontSize: 12)),
                  Text(
                      '${AppLocalizations.of(context)!.absFees} ${absfees!} ${AppLocalizations.of(context)!.egp}',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 244, 246, 248),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.wallet,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
          ),
        ],
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: () {
                            _selectDateRange(context);
                          },
                          decoration: InputDecoration(
                            icon: const Icon(Icons.calendar_today),
                            labelText:
                                AppLocalizations.of(context)!.creationDate,
                            suffixIcon: const Icon(Icons.calendar_view_day),
                            hintText: _selectedStartDate == null ||
                                    _selectedEndDate == null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(DateTime.now())
                                : '${DateFormat('yyyy-MM-dd').format(_selectedStartDate!)} - ${DateFormat('yyyy-MM-dd').format(_selectedEndDate!)}',
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              _selectedStartDate = null;
                              _selectedEndDate = null;
                              _dateController.clear();
                              getPaidCash(_selectedStartDate, _selectedEndDate);
                              getABSFees(_selectedStartDate, _selectedEndDate);
                              getPaidShipments(
                                  _selectedStartDate, _selectedEndDate);
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              buildCard(
                  AppLocalizations.of(context)!.expectedCash,
                  '$expectedCash ${AppLocalizations.of(context)!.egp}',
                  const Color(0xFF2B2E83)),
              const SizedBox(height: 16),
              buildCard(
                  AppLocalizations.of(context)!.collectedCash,
                  '$collectedCash ${AppLocalizations.of(context)!.egp}',
                  const Color(0xFF2B2E83)),
              const SizedBox(height: 16),
              buildCard(
                  AppLocalizations.of(context)!.absFeesCashCollectionFees,
                  '$ABSFees ${AppLocalizations.of(context)!.egp}',
                  const Color(0xFF2B2E83)),
              const SizedBox(height: 16),
              buildCard(
                  AppLocalizations.of(context)!.netValue,
                  '${collectedCash - ABSFees} ${AppLocalizations.of(context)!.egp}',
                  const Color(0xFF2B2E83)),
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            const Icon(Icons.payment, color: Colors.black),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.paidShipments,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (paidShipments.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: paidShipments
                              .map((shipment) => buildInfoCard(
                                    locale.toString() == 'en'
                                        ? shipment["AWB"]
                                        : shipment["رقم الشحنة"],
                                    locale.toString() == 'en'
                                        ? shipment["ABS Fees"].toString()
                                        : shipment["مصاريف الشحن"].toString(),
                                    locale.toString() == 'en'
                                        ? shipment["Delivery Date"]
                                        : shipment["تاريخ التسليم"],
                                    locale.toString() == 'en'
                                        ? shipment["Payment Date"]
                                        : shipment["تاريخ الدفع"],
                                    locale.toString() == 'en'
                                        ? shipment["Cash"].toString()
                                        : shipment["المبلغ"].toString(),
                                  ))
                              .toList(),
                        ),
                      if ((!isClicked && paidShipments.length + 5 == limit) ||
                          (paidShipments.length == limit))
                        Center(
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isClicked = true;
                                limit += 5;
                                getPaidShipments(
                                    _selectedStartDate, _selectedEndDate);
                              });
                            },
                            child: Text(AppLocalizations.of(context)!.loadMore),
                          ),
                        ),
                      if (paidShipments.isEmpty)
                        Center(
                            child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(
                            AppLocalizations.of(context)!.noPaidShipments,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ))
                    ],
                  ),
                ),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
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
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 96, 96, 96),
              ),
            ),
            const SizedBox(
              height: 25,
            )
          ],
        ),
      ),
    );
  }
}
