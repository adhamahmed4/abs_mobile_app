import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

class BusinessInfoPage extends StatefulWidget {
  @override
  _BusinessInfoPageState createState() => _BusinessInfoPageState();
}

class _BusinessInfoPageState extends State<BusinessInfoPage> {
  TextEditingController _englishNameController =
      TextEditingController(text: "ABS Courier & Freight Systems");
  TextEditingController _arabicNameController =
      TextEditingController(text: "ايه بى اس كورير اند فريت سيستيمز");
  TextEditingController _storeURLController =
      TextEditingController(text: "https://www.abs.com");

  bool _englishNameEditable =
      false; // Track if the name field has been modified
  bool _arabicNameEditable = false; // Track if the name field has been modified
  bool _storeURLEditable = false; // Track if the name field has been modified

  List<String> _selectedSalesChannels = ['Facebook', 'Instagram'];
  String _selectedIndustry = 'Sportswear and equipment';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Info'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 32),
            child: Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _englishNameController,
                      readOnly: !_englishNameEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: "Business Name (English)",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_englishNameEditable) {
                                setState(() {
                                  _englishNameEditable = !_englishNameEditable;
                                });
                              } else {
                                setState(() {
                                  _englishNameEditable = !_englishNameEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_englishNameEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _arabicNameController,
                      readOnly: !_arabicNameEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Business Name (Arabic)',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_arabicNameEditable) {
                                setState(() {
                                  _arabicNameEditable = !_arabicNameEditable;
                                });
                              } else {
                                setState(() {
                                  _arabicNameEditable = !_arabicNameEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_arabicNameEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                        ),
                        labelText: 'Sales Channel',
                      ),
                      child: MultiSelectDialogField(
                        items: <MultiSelectItem<String>>[
                          MultiSelectItem<String>('Facebook', 'Facebook'),
                          MultiSelectItem<String>('Instagram', 'Instagram'),
                          MultiSelectItem<String>('Website', 'Website'),
                          MultiSelectItem<String>('Marketplace', 'Marketplace'),
                        ],
                        listType: MultiSelectListType.CHIP,
                        onConfirm: (selectedItems) {
                          setState(() {
                            _selectedSalesChannels =
                                List<String>.from(selectedItems);
                          });
                        },
                        initialValue: _selectedSalesChannels,
                        buttonText: Text('Select Sales Channel'),
                        chipDisplay: MultiSelectChipDisplay(),
                        searchHint: 'Search Sales Channels',
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFFFAB4A)),
                        ),
                        labelText: 'Industry',
                      ),
                      child: Container(
                        height: 20,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedIndustry,
                            onChanged: (newValue) {
                              setState(() {
                                _selectedIndustry = newValue!;
                              });
                            },
                            items: <String>[
                              'Electronics',
                              'Books, arts, and media',
                              'Healthcare supplements',
                              'Cosmetics and personal care',
                              'Fashion',
                              'Furniture and appliances',
                              'Home and living',
                              'Jewelery and accessories',
                              'Leather',
                              'Mothers and babies',
                              'Medical supplies',
                              'Office equipment and supplies',
                              'Pet supplies',
                              'Sportswear and equipment',
                              'Toys',
                              'E-commerce',
                              'Food',
                              'Shoes'
                            ].map<DropdownMenuItem<String>>((String value) {
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
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                    child: TextField(
                      controller: _storeURLController,
                      readOnly: !_storeURLEditable,
                      decoration: InputDecoration(
                        fillColor: Color.fromARGB(255, 250, 250, 250),
                        filled: true,
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFFFAB4A))),
                        labelText: 'Store URL',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              if (_storeURLEditable) {
                                setState(() {
                                  _storeURLEditable = !_storeURLEditable;
                                });
                              } else {
                                setState(() {
                                  _storeURLEditable = !_storeURLEditable;
                                });
                              }
                            });
                          },
                          icon: Icon(_storeURLEditable
                              ? Icons.save
                              : Icons
                                  .edit), // Change the icon based on edit mode
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
