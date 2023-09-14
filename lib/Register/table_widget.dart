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
          SizedBox(height: 8),
          // Show the "Scroll to see more" message when needed
          if (columnsCount > 5) // Adjust the threshold as needed
            Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Scroll to see more',
                  style: TextStyle(
                    color: Colors.blue, // You can choose your preferred color
                  ),
                ),
              ),
            ),
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
                dataRowHeight: 40, // Adjust the row height as needed
                headingRowHeight: 40, // Adjust the header row height as needed
                columns: List.generate(
                  columnsCount,
                  (index) {
                    if (index == 0) {
                      return DataColumn(
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Zone'),
                        ),
                      );
                    } else {
                      return DataColumn(
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text('Zone$index'),
                        ),
                      );
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
                            return DataCell(
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(rowData['#'] ?? ''),
                                ),
                              ),
                            ); // Use default value if '#' is null
                          } else {
                            // Data columns: Zone values
                            final zoneValue = rowData['Zone$cellIndex'];
                            return DataCell(
                              Center(
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(zoneValue.toString() + ' EGP'),
                                ),
                              ),
                            );
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
