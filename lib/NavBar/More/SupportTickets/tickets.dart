import 'package:abs_mobile_app/NavBar/More/SupportTickets/addTicket.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TicketsPage extends StatefulWidget {
  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  bool isLoading = true;
  List<dynamic> _tickets = [];
  Locale? locale;

  @override
  void initState() {
    super.initState();
    getTickets();
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

  Future<void> getTickets() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/tickets-by-sub-account-id/1/10000');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _tickets = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _tickets = [];
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
            AppLocalizations.of(context)!.supportTickets,
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
                if (!isLoading && _tickets.isEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noTickets,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ListView(
                    children: _tickets.map((ticket) {
                      return Card(
                        color: const Color.fromARGB(255, 229, 229, 229),
                        elevation: 4,
                        margin: const EdgeInsets.all(10),
                        child: ListTile(
                          title: Text(
                              '${AppLocalizations.of(context)!.awbDots}${locale.toString() == 'en' ? ticket['AWB'] : ticket['رقم الشحنة']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  '${AppLocalizations.of(context)!.ticketIssuer}${locale.toString() == 'en' ? ticket['Ticket Issuer'] : ticket['مصدر التذكرة']}'),
                              Text(
                                  '${AppLocalizations.of(context)!.ticketType}${locale.toString() == 'en' ? ticket['Ticket Type'] : ticket['نوع التذكرة']}'),
                              Text(
                                  '${AppLocalizations.of(context)!.ticketStatus}${locale.toString() == 'en' ? ticket['Ticket Status'] : ticket['حالة التذكرة']}'),
                              Text(
                                  '${AppLocalizations.of(context)!.description}${locale.toString() == 'en' ? ticket['Description'] : ticket['وصف']}'),
                              Text(
                                  '${AppLocalizations.of(context)!.lastActionDate}${formatDateTime(locale.toString() == 'en' ? ticket['Last Action Date'] : ticket['تاريخ آخر إجراء'])}'),
                              Row(
                                children: [
                                  Text(AppLocalizations.of(context)!.status),
                                  Text(
                                    '${locale.toString() == 'en' ? ticket['Closed'] ? 'Closed' : 'Active' : ticket['تم غلق التذكرة'] ? 'مغلق' : 'نشط'}',
                                    style: TextStyle(
                                      color: locale.toString() == 'en'
                                          ? ticket['Closed']
                                              ? Colors.red
                                              : Colors.green
                                          : ticket['تم غلق التذكرة']
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => AddTicketPage(),
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
                  ).then((value) => getTickets());
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
