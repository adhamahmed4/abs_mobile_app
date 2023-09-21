import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import '../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class ZoneDetailsPage extends StatefulWidget {
  @override
  _ZoneDetailsPageState createState() => _ZoneDetailsPageState();
}

class _ZoneDetailsPageState extends State<ZoneDetailsPage> {
  List<dynamic> zones = [];
  Map<int, List<dynamic>> zoneCities = {}; // Store cities for each zone

  bool isLoading = true;
  Locale? locale;

  Future<void> getZones() async {
    final url = Uri.parse('${AppConfig.baseUrl}/zones/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (mounted) {
        setState(() {
          zones = jsonData;
        });
      }

      for (var zone in zones) {
        final zoneID =
            locale.toString() == 'en' ? zone['Zone ID'] : zone['رقم المنطقة'];
        final cities = await getZoneCities(zoneID);
        if (mounted) {
          setState(() {
            zoneCities[zoneID] = cities;
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

  Future<List<dynamic>> getZoneCities(int zoneID) async {
    final url = Uri.parse('${AppConfig.baseUrl}/cities-by-zone-id/$zoneID/1');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData;
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    getZones();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Zone Details',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Column(
                children: zones.map((zone) {
                  final cities = zoneCities[locale.toString() == 'en'
                          ? zone['Zone ID']
                          : zone['رقم المنطقة']] ??
                      [];

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 4,
                      color: const Color.fromARGB(255, 229, 229, 229),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                locale.toString() == 'en'
                                    ? zone['Zone']
                                    : zone['اسم المنطقة'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                            Divider(),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 8.0,
                              children: cities.map((city) {
                                return InkWell(
                                  onTap: () {
                                    // Handle city tap if needed
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.orange,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      city['City Name'],
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
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
