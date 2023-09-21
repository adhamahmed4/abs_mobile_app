import 'package:abs_mobile_app/NavBar/More/SupportTickets/addTicket.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

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
          title: const Text(
            'Tickets',
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
                if (!isLoading && _tickets.isEmpty)
                  const Center(
                    child: Text(
                      'No Tickets',
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
                              'AWB: ${locale.toString() == 'en' ? ticket['AWB'] : ticket['رقم الشحنة']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Ticket Issuer: ${locale.toString() == 'en' ? ticket['Ticket Issuer'] : ticket['مصدر التذكرة']}'),
                              Text(
                                  'Ticket Type: ${locale.toString() == 'en' ? ticket['Ticket Type'] : ticket['نوع التذكرة']}'),
                              Text(
                                  'Ticket Status: ${locale.toString() == 'en' ? ticket['Ticket Status'] : ticket['حالة التذكرة']}'),
                              Text(
                                  'Description: ${locale.toString() == 'en' ? ticket['Description'] : ticket['وصف']}'),
                              Text(
                                  'Last Action Date: ${formatDateTime(locale.toString() == 'en' ? ticket['Last Action Date'] : ticket['تاريخ آخر إجراء'])}'),
                              Row(
                                children: [
                                  Text('Status: '),
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
