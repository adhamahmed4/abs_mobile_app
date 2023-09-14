import 'package:abs_mobile_app/Register/table_widget.dart';
import 'package:abs_mobile_app/Register/zoneDetails.dart';
import 'package:flutter/material.dart';
import '../../../Configurations/app_config.dart';
import 'package:http/http.dart' as http; // Import the http package
import 'dart:convert';

class PricePlanPage extends StatefulWidget {
  @override
  _PricePlanPageState createState() => _PricePlanPageState();
}

class _PricePlanPageState extends State<PricePlanPage> {
  final parsedTableData = <Map<String, dynamic>>[];

  bool isLoading = true;

  Future<void> getPricePlan() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/price-plans-matrix-by-sub-account-ID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body) as List<dynamic>;

      for (var apiRow in jsonData) {
        final row = <String, dynamic>{};
        for (var key in apiRow.keys) {
          row[key] = apiRow[key];
        }
        if (mounted) {
          setState(() {
            parsedTableData.add(row);
          });
        }
      }
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getPricePlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Price Plan'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            Column(
              children: [
                SingleChildScrollView(
                  child: TableWidget(parsedTableData),
                ),
                Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              transitionDuration: Duration(
                                  milliseconds:
                                      300), // Adjust the animation duration
                              pageBuilder: (_, __, ___) => ZoneDetailsPage(),
                              transitionsBuilder: (_,
                                  Animation<double> animation,
                                  __,
                                  Widget child) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(1.0, 0.0),
                                    end: Offset.zero,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            ),
                          );
                        },
                        child: Text('View Zones Details'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          if (isLoading)
            Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
