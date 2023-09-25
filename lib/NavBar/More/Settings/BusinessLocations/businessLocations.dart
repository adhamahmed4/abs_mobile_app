// ignore_for_file: library_private_types_in_public_api
import 'package:abs_mobile_app/NavBar/More/Settings/BusinessLocations/addBusinessLocation.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BusinessLocationsPage extends StatefulWidget {
  const BusinessLocationsPage({super.key});

  @override
  _BusinessLocationsPageState createState() => _BusinessLocationsPageState();
}

class _BusinessLocationsPageState extends State<BusinessLocationsPage> {
  List<dynamic>? locations = [];
  bool isLoading = true;
  Locale? locale;

  Future<void> getBusinessLocations() async {
    final url =
        Uri.parse('${AppConfig.baseUrl}/cust-addresses-by-subAccountID');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            locations = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            locations = [];
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
  void initState() {
    super.initState();
    getBusinessLocations();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  Color _getColorForLocationType(String locationType) {
    switch (locationType) {
      case 'Pickup':
        return Colors.orange;
      case 'بيكاب':
        return Colors.orange;
      case 'Return':
        return Colors.blue;
      case 'مرتجع':
        return Colors.blue;
      case 'Company':
        return Colors.deepPurple;
      case 'شركة':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.businessLocations,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 100),
                  child: ListView(
                    children: [
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      // children: [
                      Card(
                        margin: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)!.newLocations,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                AppLocalizations.of(context)!
                                    .manageYourLocationsToControlYourShipmentsPickupAndReturnDestinations,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 300),
                                        pageBuilder: (_, __, ___) =>
                                            AddNewLocationPage(
                                          locationID: 0,
                                        ),
                                        transitionsBuilder: (_,
                                            Animation<double> animation,
                                            __,
                                            Widget child) {
                                          return SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(1.0, 0.0),
                                              end: Offset.zero,
                                            ).animate(animation),
                                            child: child,
                                          );
                                        },
                                      ),
                                    ).then((_) {
                                      getBusinessLocations();
                                    });
                                  },
                                  child: Text(AppLocalizations.of(context)!
                                      .addNewLocation),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      locations!.isEmpty
                          ? Container()
                          : Card(
                              margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: locations!.map((location) {
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(18.0),
                                      child: Card(
                                        color: const Color.fromARGB(
                                            255, 226, 226, 226),
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  PageRouteBuilder(
                                                    transitionDuration:
                                                        const Duration(
                                                            milliseconds: 300),
                                                    pageBuilder: (_, __, ___) =>
                                                        AddNewLocationPage(
                                                      locationID: locale
                                                                  .toString() ==
                                                              'en'
                                                          ? location["ID"]
                                                          : location[
                                                              "رقم التسلسل"],
                                                    ),
                                                    transitionsBuilder: (_,
                                                        Animation<double>
                                                            animation,
                                                        __,
                                                        Widget child) {
                                                      return SlideTransition(
                                                        position: Tween<Offset>(
                                                          begin: const Offset(
                                                              1.0, 0.0),
                                                          end: Offset.zero,
                                                        ).animate(animation),
                                                        child: child,
                                                      );
                                                    },
                                                  ),
                                                ).then((_) {
                                                  getBusinessLocations();
                                                });
                                              },
                                              child: ListTile(
                                                title: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 4.0),
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        locale.toString() ==
                                                                'en'
                                                            ? location[
                                                                "Location Name"]
                                                            : location[
                                                                "اسم العنوان"],
                                                        style: const TextStyle(
                                                          fontSize: 14.0,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4.0,
                                                                vertical: 4.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _getColorForLocationType(
                                                              locale.toString() ==
                                                                      'en'
                                                                  ? location[
                                                                      "Location Type"]
                                                                  : location[
                                                                      "نوع العنوان"]),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: Text(
                                                          locale.toString() ==
                                                                  'en'
                                                              ? location[
                                                                  "Location Type"]
                                                              : location[
                                                                  "نوع العنوان"],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          width: 8.0),
                                                      Expanded(
                                                        child: Container(),
                                                      ),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal: 4.0,
                                                                vertical: 4.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: location[
                                                                  "isActive"]
                                                              ? Colors.green
                                                              : Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      8.0),
                                                        ),
                                                        child: Text(
                                                          location["isActive"]
                                                              ? AppLocalizations
                                                                      .of(
                                                                          context)!
                                                                  .active
                                                              : AppLocalizations
                                                                      .of(context)!
                                                                  .inactive,
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 10.0,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                subtitle: Text(
                                                  locale.toString() == 'en'
                                                      ? location["Address"]
                                                      : location["العنوان"],
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          if (isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
