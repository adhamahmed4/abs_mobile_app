import 'package:abs_mobile_app/Courier/History/pickedShipments.dart';
import 'package:abs_mobile_app/Courier/History/deliveredShipments.dart';
import 'package:abs_mobile_app/Courier/History/undeliveredShipments.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:abs_mobile_app/Courier/Home/home.dart';
import 'package:abs_mobile_app/Courier/Shipments/currentShipments.dart';
import 'package:abs_mobile_app/Courier/Shipments/pendingShipments.dart';

class ShipmentsPage extends StatefulWidget {
  @override
  _ShipmentsPageState createState() => _ShipmentsPageState();
}

class _ShipmentsPageState extends State<ShipmentsPage> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 16.0),
                child: ToggleSwitch(
                  initialLabelIndex: _currentIndex,
                  minWidth: 120.0,
                  cornerRadius: 10.0,
                  minHeight: 27.0,
                  labels: [
                    AppLocalizations.of(context)!.delivered,
                    AppLocalizations.of(context)!.undelivered
                  ],
                  onToggle: (index) {
                    setState(() {
                      _currentIndex = index!;
                      _pageController.animateToPage(
                        index!,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    });
                  },
                  borderColor: [const Color.fromARGB(255, 227, 227, 227)],
                  activeBgColor: [Colors.white],
                  activeFgColor: Colors.black,
                  inactiveBgColor: const Color.fromARGB(255, 227, 227, 227),
                  radiusStyle: true,
                ),
              ),
            ),
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: DeliveredShipmentsPage(),
                ),
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: UndeliveredShipments(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
