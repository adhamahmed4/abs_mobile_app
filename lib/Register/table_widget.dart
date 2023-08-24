import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<String> tableData;

  TableWidget(this.tableData);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Table Data:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
              ),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columnSpacing: 8,
                columns: List.generate(
                  8,
                  (index) => DataColumn(
                    label: Text(
                      'Header ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                rows: List.generate(
                  8,
                  (rowIndex) => DataRow(
                    cells: List.generate(
                      8,
                      (cellIndex) => DataCell(
                        Container(
                          width: 80, // Adjust the width as needed
                          alignment: Alignment.center,
                          child: Text(tableData[rowIndex * 8 + cellIndex]),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
