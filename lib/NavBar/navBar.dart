import 'package:abs_mobile_app/NavBar/More/More.dart';
import 'package:abs_mobile_app/NavBar/Home/Home.dart';
import 'package:abs_mobile_app/NavBar/Orders/orders.dart';
import 'package:abs_mobile_app/Track/track.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _selectedIndex = 0;
  final PageController _pageController =
      PageController(); // Added PageController

  final List<Widget> _pages = [
    const HomePage(),
    OrdersPage(),
    TrackPage(),
    MorePage(),
  ];

  void switchPage(int index) {
    _pageController.animateToPage(
      index,
      duration:
          Duration(milliseconds: 300), // You can adjust the animation duration
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF1F5),
      body: PageView(
        controller: _pageController, // Use the PageController
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0.25,
                  blurRadius: 5,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              activeColor: Colors.orange,
              padding: const EdgeInsets.all(16),
              gap: 8,
              selectedIndex: _selectedIndex, // Set the selected index
              onTabChange: (index) {
                switchPage(index); // Call your switchPage function
              },
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: AppLocalizations.of(context)!.navBarHome,
                ),
                GButton(
                  icon: Icons.local_shipping,
                  text: AppLocalizations.of(context)!.navBarOrders,
                ),
                GButton(
                  icon: Icons.room,
                  text: AppLocalizations.of(context)!.navBarTrack,
                ),
                GButton(
                  icon: Icons.menu,
                  text: AppLocalizations.of(context)!.navBarMore,
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: MyApp.getLocale(context).toString() == 'en'
                ? MediaQuery.of(context).size.width / 4 * _selectedIndex
                : MediaQuery.of(context).size.width / 4 * (3 - _selectedIndex),
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width / 4,
              height: 4,
              decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
