import 'package:abs_mobile_app/Login/login.dart';
import 'package:abs_mobile_app/NavBar/More/SupportTickets/tickets.dart';
import 'package:abs_mobile_app/NavBar/More/TermsAndConditions/termsAndConditions.dart';
import 'package:abs_mobile_app/NavBar/More/Wallet/wallet.dart';
import 'package:abs_mobile_app/NavBar/More/Settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Configurations/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  bool isLoading = true;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _avatarController = TextEditingController();

  String generateAvatarLetter(String name) {
    if (name.isEmpty) return '';
    final names = name.split(" ");
    if (names.length >= 2) {
      return names[0][0] + names[1][0];
    } else if (names.length == 1) {
      return names[0][0];
    }
    return '';
  }

  Future<void> getUserInfo() async {
    final url = Uri.parse('${AppConfig.baseUrl}/users-with-info-client');
    final response = await http.get(url, headers: AppConfig.headers);

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      if (mounted) {
        setState(() {
          _nameController.text =
              responseBody[0]['firstName'] + ' ' + responseBody[0]['lastName'];
          _mobileController.text = responseBody[0]['contactNumber'];
          _avatarController.text = responseBody[0]['avatar'] ?? '';
          isLoading = false;
        });
      }
    } else {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text(AppLocalizations.of(context)!.failedToGetUserInfo),
              content: Text(AppLocalizations.of(context)!.failedToGetUserInfo),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.ok),
                ),
              ],
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.navBarMore,
          style:
              const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          if (!isLoading)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipOval(
                            child: Container(
                                color: const Color(0xFFEEF1F5),
                                child: _avatarController.text != ''
                                    ? FadeInImage.assetNetwork(
                                        placeholder:
                                            'assets/images/profile_picture.jpg',
                                        image:
                                            '${AppConfig.baseUrl}/images/getImage?name=${_avatarController.text}',
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      )
                                    : CircleAvatar(
                                        backgroundColor:
                                            const Color(0xFFEEF1F5),
                                        radius: 40,
                                        child: Text(
                                          generateAvatarLetter(
                                              _nameController.text),
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                      )),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _nameController.text,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _mobileController.text,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey.shade200,
                        child: ListTileTheme(
                          iconColor: Colors.black,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: const Icon(Icons.settings),
                                title: Text(
                                    AppLocalizations.of(context)!.settings),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (_, __, ___) =>
                                          SettingsPage(),
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
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                tileColor: Colors.white,
                                leading: const Icon(Icons.wallet),
                                title:
                                    Text(AppLocalizations.of(context)!.wallet),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WalletPage()),
                                  );
                                },
                              ),
                              const Divider(),
                              ListTile(
                                tileColor: Colors.white,
                                leading: const Icon(Icons.support),
                                title: Text(AppLocalizations.of(context)!
                                    .supportTickets),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (_, __, ___) =>
                                          TicketsPage(),
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
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: Colors.grey.shade200,
                        child: ListTileTheme(
                          iconColor: Colors.black,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: const Icon(Icons.text_snippet),
                                title: Text(AppLocalizations.of(context)!
                                    .termsAndConditions),
                                trailing: const Icon(Icons.arrow_forward),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration:
                                          const Duration(milliseconds: 300),
                                      pageBuilder: (_, __, ___) =>
                                          TermsAndConditionsPage(),
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
                                  );
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
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color.fromARGB(255, 255, 233, 233),
                        child: ListTileTheme(
                          iconColor: Colors.red,
                          child: Column(
                            children: [
                              ListTile(
                                tileColor: Colors.white,
                                leading: const Icon(Icons.logout),
                                title: Text(
                                  AppLocalizations.of(context)!.logout,
                                  style: const TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Center(
                                            child: Text(
                                                AppLocalizations.of(context)!
                                                    .confirmLogout)),
                                        content: Text(
                                            AppLocalizations.of(context)!
                                                .areYouSureYouWantToLogout),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .cancel,
                                              )),
                                          TextButton(
                                            onPressed: () async {
                                              final prefs =
                                                  await SharedPreferences
                                                      .getInstance();
                                              await prefs.clear();
                                              Navigator.of(context).pop();
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()),
                                              );
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .logout,
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
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
          if (isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
