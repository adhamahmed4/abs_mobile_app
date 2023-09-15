import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:abs_mobile_app/Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Color.fromARGB(255, 244, 246, 248),
        iconTheme: IconThemeData(
            color: Colors.black), // Set the back arrow color to black
        actions: [
          Row(
            children: [
              Container(
                width: 250,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by AWB...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: 16.0,
                    ),
                  ),
                  onSubmitted: (_) {
                    // Handle search submission here if needed
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                onPressed: () {
                  // Handle search button press here if needed
                },
              ),
              IconButton(
                icon: Icon(Icons.clear, color: Colors.black),
                onPressed: () {
                  _searchController.clear();
                  // Handle clear button press here if needed
                },
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text('Search Page Content Goes Here'),
      ),
    );
  }
}
