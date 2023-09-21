import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> tableData;

  TableWidget(this.tableData);

  @override
  Widget build(BuildContext context) {
    final columnsCount =
        tableData.length + 1; // Number of columns (zones + header)

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          // Show the "Scroll to see more" message when needed
          if (columnsCount > 5) // Adjust the threshold as needed
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  AppLocalizations.of(context)!.scrollToSeeMore,
                  style: const TextStyle(
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
                          child: Text(AppLocalizations.of(context)!.zone),
                        ),
                      );
                    } else {
                      return DataColumn(
                        label: Container(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                              '${AppLocalizations.of(context)!.zone}$index'),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(zoneValue.toString() +
                                      ' ' +
                                      AppLocalizations.of(context)!.egp),
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
