import 'package:abs_mobile_app/More/Settings/settings.dart';
import 'package:flutter/material.dart';

class NearestBranchPage extends StatefulWidget {
  @override
  _NearestBranchPageState createState() => _NearestBranchPageState();
}

class _NearestBranchPageState extends State<NearestBranchPage> {
  List<String> _branchNames = ['Dokki', 'Maadi', 'Nasr City', 'Heliopolis'];
  late String _selectedBranchName = _branchNames[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nearest Branch'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                        ),
                        labelText: 'Branch',
                      ),
                      child: Container(
                        height: 20,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedBranchName,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedBranchName = newValue!;
                              });
                            },
                            items: _branchNames
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 16, 0),
            child: Align(
              alignment: Alignment.bottomRight,
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
                onPressed: () => {
                  Navigator.pop(context), // Go back once
                  Navigator.pop(context) // Go back again
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text('Submit'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
