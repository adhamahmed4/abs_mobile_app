// import 'package:flutter/material.dart';
// import 'package:flutter_date_range_picker/flutter_date_range_picker.dart' as DateRangePicker;

// class WalletPage extends StatefulWidget {
//   @override
//   _WalletPageState createState() => _WalletPageState();
// }

// class _WalletPageState extends State<WalletPage> {
//   TextEditingController _dateController = TextEditingController();
//   DateTime _selectedStartDate = DateTime.now(); // Initialize with a default value
//   DateTime _selectedEndDate = DateTime.now(); 

//   Future<void> _selectDateRange(BuildContext context) async {
//     final picked = await DateRangePicker.showDatePicker(
//       context: context,
//       initialFirstDate: DateTime.now(),
//       initialLastDate: DateTime.now(),
//       firstDate: DateTime(1950),
//       lastDate: DateTime(2100),
//     );

//     if (picked != null && picked.length == 2) {
//       setState(() {
//         _selectedStartDate = picked[0];
//         _selectedEndDate = picked[1];
//         final formattedStartDate =
//             "${_selectedStartDate.year}-${_selectedStartDate.month}-${_selectedStartDate.day}";
//         final formattedEndDate =
//             "${_selectedEndDate.year}-${_selectedEndDate.month}-${_selectedEndDate.day}";
//         _dateController.text = "$formattedStartDate - $formattedEndDate";
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wallet'),
//         centerTitle: true,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 16),
//             Container(
//               padding: EdgeInsets.all(16),
//               child: TextField(
//                 controller: _dateController,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   icon: Icon(Icons.calendar_today),
//                   labelText: 'Select Date Range',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.calendar_view_day),
//                     onPressed: () {
//                       _selectDateRange(context);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
