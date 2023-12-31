import 'package:abs_mobile_app/NavBar/More/Settings/TeamMembers/addTeamMember.dart';
import 'package:abs_mobile_app/main.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TeamMembersPage extends StatefulWidget {
  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  bool isLoading = true;
  List<dynamic> _teamMembers = [];
  Locale? locale;

  @override
  void initState() {
    super.initState();
    getTeamMembers();
    if (mounted) {
      setState(() {
        locale = MyApp.getLocale(context);
      });
    }
  }

  Future<void> getTeamMembers() async {
    final url = Uri.parse('${AppConfig.baseUrl}/team-members');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        if (mounted) {
          setState(() {
            _teamMembers = jsonData;
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _teamMembers = [];
            isLoading = false;
          });
        }
      }
    } else {
      isLoading = false;
      throw Exception('Failed to load data');
    }
  }

  Future<void> activateTeamMember(int ID) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users/activate/$ID');
    final response = await http.put(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      getTeamMembers();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> deActivateTeamMember(int ID) async {
    final url = Uri.parse('${AppConfig.baseUrl}/users/de-activate/$ID');
    final response = await http.put(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      getTeamMembers();
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.teamMembers,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          iconTheme: const IconThemeData(color: Colors.black)),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (!isLoading && _teamMembers.isEmpty)
                  Center(
                    child: Text(
                      AppLocalizations.of(context)!.noTeamMembers,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey, // Customize the color
                      ),
                    ),
                  ),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ListView(
                    children: _teamMembers.map((teamMember) {
                      return Card(
                        color: const Color.fromARGB(255, 229, 229, 229),
                        elevation: 4,
                        margin: EdgeInsets.all(10),
                        child: ListTile(
                          leading: locale.toString() == 'en'
                              ? teamMember["Avatar"] != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        '${AppConfig.baseUrl}/images/getImage?name=${teamMember["Avatar"]}',
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    )
                              : teamMember["الصورة"] != null
                                  ? CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(
                                        '${AppConfig.baseUrl}/images/getImage?name=${teamMember["الصورة"]}',
                                      ),
                                    )
                                  : const CircleAvatar(
                                      radius: 30,
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                          title: Text(
                              '${locale.toString() == 'en' ? teamMember['Username'] : teamMember['اسم المستخدم']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(AppLocalizations.of(context)!.status),
                                  Text(
                                    '${locale.toString() == 'en' ? teamMember['Status'] ? 'Active' : 'Inactive' : teamMember['الحالة'] ? 'نشط' : 'غير نشط'}',
                                    style: TextStyle(
                                      color: locale.toString() == 'en'
                                          ? teamMember['Status']
                                              ? Colors.green
                                              : Colors.red
                                          : teamMember['الحالة']
                                              ? Colors.green
                                              : Colors.red,
                                    ),
                                  ),
                                  const Spacer(), // Add this Spacer to push the icon to the right
                                  InkWell(
                                    onTap: () {
                                      if (locale.toString() == 'en'
                                          ? teamMember['Status']
                                          : teamMember['الحالة']) {
                                        isLoading = true;
                                        deActivateTeamMember(teamMember['id']);
                                      } else {
                                        isLoading = true;
                                        activateTeamMember(teamMember['id']);
                                      }
                                    },
                                    child: Icon(
                                      locale.toString() == 'en'
                                          ? teamMember['Status']
                                              ? Icons
                                                  .cancel // Change this to your deactivate icon
                                              : Icons.check_circle
                                          : teamMember['الحالة']
                                              ? Icons.cancel
                                              : Icons.check_circle,
                                      color: locale.toString() == 'en'
                                          ? teamMember['Status']
                                              ? Colors.red
                                              : Colors.green
                                          : teamMember['الحالة']
                                              ? Colors.red
                                              : Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                  '${AppLocalizations.of(context)!.role}${locale.toString() == 'en' ? teamMember['Roles'] : teamMember['صلاحيات']}'),
                              Text(
                                  '${AppLocalizations.of(context)!.subAccountName}${locale.toString() == 'en' ? teamMember['Sub-Account Name'] : teamMember['اسم الحساب الفرعي']}'),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: Duration(
                          milliseconds: 300), // Adjust the animation duration
                      pageBuilder: (_, __, ___) => AddTeamMemberPage(),
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
                  ).then((value) => getTeamMembers());
                },
                child: const Icon(Icons.add),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
