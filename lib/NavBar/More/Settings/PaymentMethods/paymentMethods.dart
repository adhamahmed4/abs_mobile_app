import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/BankTransfer/bankTransfer.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/MobileCash/mobileCash.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/NearestBranch/nearestBranch.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/PaymentMethods/WalletDetails/walletDetails.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Payment Methods',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(255, 244, 246, 248),
          shadowColor: Colors.transparent,
          iconTheme: IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 32),
            Text(
              'Choose a Payment Method',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 32),
            PaymentMethodCard(
              icon: Icons.account_balance,
              title: 'Bank Transfer',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: 300), // Adjust the animation duration
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
              },
            ),
            PaymentMethodCard(
              icon: Icons.phone_android,
              title: 'Mobile Cash',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: 300), // Adjust the animation duration
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
              },
            ),
            PaymentMethodCard(
              icon: Icons.account_balance_wallet,
              title: 'Wallet',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: 300), // Adjust the animation duration
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
              },
            ),
            PaymentMethodCard(
              icon: Icons.location_on,
              title: 'Nearest Branch',
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(
                        milliseconds: 300), // Adjust the animation duration
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
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                icon,
                size: 36,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
