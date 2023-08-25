import 'package:flutter/material.dart';

class TableWidget extends StatelessWidget {
  final List<String> tableData;

  TableWidget(this.tableData);

  @override
  Widget build(BuildContext context) {
    final columnsCount = 8; // Number of columns

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
                  (index) => DataColumn(
                    label: Text(
                      'Header ${index + 1}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                rows: List.generate(
                  (tableData.length / columnsCount).ceil(),
                  (rowIndex) => DataRow(
                    cells: List.generate(
                      columnsCount,
                      (cellIndex) {
                        final dataIndex = rowIndex * columnsCount + cellIndex;
                        if (dataIndex < tableData.length) {
                          return DataCell(
                            Container(
                              width: 80,
                              alignment: Alignment.center,
                              child: Text(tableData[dataIndex]),
                            ),
                          );
                        } else {
                          return DataCell(
                              Container()); // Empty cell if data not available
                        }
                      },
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
