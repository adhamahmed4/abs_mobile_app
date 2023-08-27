import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tableData;

  TableWidget(this.tableData);

  @override
  Widget build(BuildContext context) {
    final columnsCount =
        tableData.length + 1; // Number of columns (zones + header)

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
                  columnsCount,
                  (index) {
                    if (index == 0) {
                      return DataColumn(label: Text('Zone'));
                    } else {
                      return DataColumn(label: Text('Zone$index'));
                    }
                  },
                ),
                rows: List.generate(
                  tableData.length,
                  (rowIndex) {
                    final rowData = tableData[rowIndex];
                    return DataRow(
                      cells: List.generate(
                        columnsCount,
                        (cellIndex) {
                          if (cellIndex == 0) {
                            // First column: Zone name
                            return DataCell(Text(rowData['#'] ??
                                '')); // Use default value if '#'' is null
                          } else {
                            // Data columns: Zone values
                            final zoneValue = rowData['Zone$cellIndex'];
                            return DataCell(Text(zoneValue.toString()));
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
