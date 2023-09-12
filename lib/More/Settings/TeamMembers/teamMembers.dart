import 'package:abs_mobile_app/More/Settings/TeamMembers/addTeamMember.dart';
import 'package:flutter/material.dart';
import '../../../../Configurations/app_config.dart';
import 'dart:convert'; // for JSON decoding and encoding
import 'package:http/http.dart' as http;

class TeamMembersPage extends StatefulWidget {
  @override
  _TeamMembersPageState createState() => _TeamMembersPageState();
}

class _TeamMembersPageState extends State<TeamMembersPage> {
  bool isLoading = true;
  List<dynamic> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    getTeamMembers();
  }

  Future<void> getTeamMembers() async {
    final url = Uri.parse('${AppConfig.baseUrl}/team-members');
    final response = await http.get(url, headers: AppConfig.headers);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      if (jsonData.isNotEmpty) {
        setState(() {
          _teamMembers = jsonData;
          isLoading = false;
        });
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
        title: const Text('Team Members'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (!isLoading)
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _teamMembers.map((teamMember) {
                        return Card(
                          elevation: 2,
                          margin: EdgeInsets.all(10),
                          child: ListTile(
                            leading: teamMember["Avatar"] != null
                                ? CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      '${AppConfig.baseUrl}/images/getImage?name=${teamMember["Avatar"]}',
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 30,
                                    child: Icon(
                                      Icons.person,
                                      size: 40,
                                      color: Colors.white,
                                    ),
                                  ),
                            title: Text('${teamMember['Username']}'),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text('Status: '),
                                    Text(
                                      '${teamMember['Status'] ? 'Active' : 'Inactive'}',
                                      style: TextStyle(
                                        color: teamMember['Status']
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    Spacer(), // Add this Spacer to push the icon to the right
                                    InkWell(
                                      onTap: () {
                                        if (teamMember['Status']) {
                                          isLoading = true;
                                          deActivateTeamMember(
                                              teamMember['id']);
                                        } else {
                                          isLoading = true;
                                          activateTeamMember(teamMember['id']);
                                        }
                                      },
                                      child: Icon(
                                        teamMember['Status']
                                            ? Icons
                                                .cancel // Change this to your deactivate icon
                                            : Icons
                                                .check_circle, // Change this to your activate icon
                                        color: teamMember['Status']
                                            ? Colors.red
                                            : Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                                Text('Role: ${teamMember['Roles']}'),
                                Text(
                                    'Sub-Account Name: ${teamMember['Sub-Account Name']}'),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                Positioned(
                  bottom: 16.0, // Adjust the distance from the bottom as needed
                  right: 16.0, // Adjust the distance from the right as needed
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: Duration(
                              milliseconds:
                                  300), // Adjust the animation duration
                          pageBuilder: (_, __, ___) => AddTeamMemberPage(),
                          transitionsBuilder: (_, Animation<double> animation,
                              __, Widget child) {
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
                    child: Icon(Icons.add),
                  ),
                ),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
