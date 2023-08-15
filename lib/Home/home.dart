import 'package:abs_mobile_app/Login/login.dart';
import 'package:abs_mobile_app/More/More.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF1F5),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          MorePage(),
          MorePage(),
          MorePage(),
          MorePage(),
        ],
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
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: GNav(
              backgroundColor: Colors.white,
              color: Colors.grey,
              activeColor: Colors.orange,
              padding: EdgeInsets.all(16),
              gap: 8,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
                print(index);
              },
              tabs: [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.local_shipping,
                  text: 'Orders',
                ),
                GButton(
                  icon: Icons.room,
                  text: 'Track',
                ),
                GButton(
                  icon: Icons.menu,
                  text: 'More',
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width / 4 * _selectedIndex,
            child: Container(
              alignment: Alignment.topCenter,
              width: MediaQuery.of(context).size.width / 4,
              height: 4,
              decoration: BoxDecoration(
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
