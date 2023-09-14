import 'package:abs_mobile_app/NavBar/More/Settings/BusinessInfo/businessInfo.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/BusinessLocations/businessLocations.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/BankTransfer/bankTransfer.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/MobileCash/mobileCash.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/NearestBranch/nearestBranch.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/WalletDetails/walletDetails.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/paymentMethods.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PersonalInfo/personalInfo.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PricePlan/pricePlan.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/SubAccounts/subAccounts.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/TeamMembers/teamMembers.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Future<void> hasPaymentMethod() async {
    final url = Uri.parse('${AppConfig.baseUrl}/sub-accounts-payment-method');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final paymentMethod = jsonData['paymentMethodID'];
      if (jsonData['paymentMethodID'] != null) {
        if (paymentMethod == 1) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration:
                  Duration(milliseconds: 300), // Adjust the animation duration
              pageBuilder: (_, __, ___) => MobileCashPage(),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
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
        } else if (paymentMethod == 2) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration:
                  Duration(milliseconds: 300), // Adjust the animation duration
              pageBuilder: (_, __, ___) => WalletDetailsPage(),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
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
        } else if (paymentMethod == 3) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration:
                  Duration(milliseconds: 300), // Adjust the animation duration
              pageBuilder: (_, __, ___) => NearestBranchPage(),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
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
        } else if (paymentMethod == 4) {
          Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration:
                  Duration(milliseconds: 300), // Adjust the animation duration
              pageBuilder: (_, __, ___) => BankTransferPage(),
              transitionsBuilder:
                  (_, Animation<double> animation, __, Widget child) {
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
        }
      } else {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration:
                Duration(milliseconds: 300), // Adjust the animation duration
            pageBuilder: (_, __, ___) => PaymentMethodsPage(),
            transitionsBuilder:
                (_, Animation<double> animation, __, Widget child) {
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
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Settings',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 244, 246, 248),
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Add border radius
                child: Container(
                  color: Colors.grey.shade200,
                  child: ListTileTheme(
                    iconColor: Colors.black,
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.account_circle_outlined),
                          title: Text('Personal Info'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) => PersonalInfoPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.business_outlined),
                          title: Text('Business Info'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) => BusinessInfoPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.account_tree),
                          title: Text('Sub Accounts'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) => SubAccountsPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.request_quote_outlined),
                          title: Text('Pricing Plan'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) => PricePlanPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.payment_outlined),
                          title: Text('Payment Methods'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            hasPaymentMethod();
                          },
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.my_location_outlined),
                          title: Text('Business Locations'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) =>
                                    BusinessLocationsPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.supervised_user_circle_outlined),
                          title: Text('Team members'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: Duration(
                                    milliseconds:
                                        300), // Adjust the animation duration
                                pageBuilder: (_, __, ___) => TeamMembersPage(),
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
                        ),
                        Divider(),
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.language_outlined),
                          title: Text('Language'),
                          trailing: Icon(Icons.arrow_forward),
                          onTap: () {
                            // Handle profile tap
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12), // Add border radius
                child: Container(
                  color: Color.fromARGB(255, 255, 233, 233),
                  child: ListTileTheme(
                    iconColor: Colors.red,
                    child: Column(
                      children: [
                        ListTile(
                          tileColor: Colors.white,
                          leading: Icon(Icons.person_remove),
                          title: Text(
                            'Delete account',
                            style: TextStyle(
                              color: Colors.red, // Set the font color to red
                            ),
                          ),
                          onTap: () {
                            // Handle email tap
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
