import 'package:abs_mobile_app/NavBar/navBar.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguagePage extends StatefulWidget {
  @override
  _LanguagePageState createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  List<Map<String, String>> languages = [
    {
      'value': 'en',
      'title': 'English',
    },
    {
      'value': 'ar',
      'title': 'العربية',
    },
  ];
  String? _selectedLanguage;
  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        _selectedLanguage = MyApp.getLocale(context).toString();
      });
    }
  }

  Future<void> _saveSelectedLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLanguage', languageCode);
  }

  void _changeLanguage(BuildContext context, String languageCode) async {
    Locale newLocale = Locale(languageCode);
    await _saveSelectedLanguage(languageCode); // Save the selected language
    AppLocalizations.delegate.load(newLocale); // Load new translations
    MyApp.setLocale(context, newLocale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.language,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      fillColor: const Color.fromARGB(255, 250, 250, 250),
                      filled: true,
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                      ),
                      labelText: AppLocalizations.of(context)!.language,
                    ),
                    child: SizedBox(
                      height: 25,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedLanguage,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedLanguage = newValue!;
                            });
                          },
                          items: languages.map<DropdownMenuItem<String>>(
                            (Map<String, String> value) {
                              return DropdownMenuItem<String>(
                                value: value['value'].toString(),
                                child: Text(value['title']!),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                fixedSize: const Size(120, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(7),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 138, 138, 138),
                    width: 1.4,
                  ),
                ),
              ),
              onPressed: () {
                _changeLanguage(context, _selectedLanguage!);
              },
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(AppLocalizations.of(context)!.submit),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
