// Dan Dainiel S. Perez

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// Root of the app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedSpartanData Reports',
      debugShowCheckedModeBanner: false,
      home: const ReportDashboardPage(), // Sets the main screen
    );
  }
}

// Report Dashboard screen widget
class ReportDashboardPage extends StatelessWidget {
  const ReportDashboardPage({super.key});

  // List of report names (static for now)
  final List<String> reports = const [
    'Campus Population',
    'Admission Data',
    'Enrollment Data',
    'Number of Employees',
  ];

  // Function to show a SnackBar message (when buttons are clicked)
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RedSpartanData - Reports'),
        backgroundColor: Colors.red[700], // Red theme color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // Outer padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page title
            const Text(
              'Submitted Reports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Report table inside a card box
            Card(
              elevation: 4, // Shadow depth
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // Rounded card edges
              ),
              child: Padding(
                padding: const EdgeInsets.all(16), // Inside card padding
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Scroll if content overflows
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.red.shade100,
                    ),
                    columns: const [
                      // Column headers
                      DataColumn(
                        label: Text(
                          'Report Name',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Actions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                    // Generating table rows dynamically from the report list
                    rows: reports.map((report) {
                      return DataRow(
                        cells: [
                          // First column: report name
                          DataCell(Text(report)),

                          // Second column: action buttons
                          DataCell(
                            Row(
                              children: [
                                // Approve Button
                                ElevatedButton(
                                  onPressed: () => _showMessage(context, '$report approved'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green[600], // Green approve button
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Approve'),
                                ),
                                const SizedBox(width: 8),

                                // Return Button
                                ElevatedButton(
                                  onPressed: () => _showMessage(context, '$report returned'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[700], // Orange return button
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text('Return'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(), // Convert map result into list of DataRow
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Bottom message
            const Center(
              child: Text(
                'Review submitted reports and take action accordingly.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
