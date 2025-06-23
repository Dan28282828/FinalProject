//Ian Kenneth Caguicla

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// Main app entry point
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedSpartanData',
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(), // Load the DashboardPage as the home screen
    );
  }
}

// Dashboard page for managing users
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // List of user data with names and roles
  final List<Map<String, String>> users = const [
    {'name': 'Dan Dainiel Perez', 'role': 'Admin'},
    {'name': 'Dhaven Jun Plata', 'role': 'User'},
    {'name': 'Jhon Aldwin Arguelles', 'role': 'User'},
    {'name': 'Ian Kenneth Caguicla', 'role': 'User'},
  ];

  // Function to display SnackBar message when actions are triggered
  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Top AppBar with logo and menu
      appBar: AppBar(
        backgroundColor: Colors.red[700], // Red theme
        elevation: 0,
        automaticallyImplyLeading: false, // Remove default back button
        title: Row(
          children: [
            // Circular logo image
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/Spartan.jpg', // Image must exist in your assets folder
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'RedSpartanData',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const Spacer(),

            // Popup menu button
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) => _showMessage(context, '$value selected'),
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'profile', child: Text('Profile')),
                PopupMenuItem(value: 'activity', child: Text('User Activity')),
                PopupMenuItem(value: 'manage', child: Text('Manage Users')),
                PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
            ),
          ],
        ),
      ),

      // Main Body content
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title section
            const Text(
              'User Management',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Card Box containing DataTable
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Horizontal scroll if needed
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith(
                      (states) => Colors.red.shade100,
                    ),
                    columns: const [
                      DataColumn(
                        label: Text('Name', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Role', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      DataColumn(
                        label: Text('Actions', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],

                    // Generate rows based on the users list
                    rows: users.map((user) {
                      return DataRow(
                        cells: [
                          DataCell(Text(user['name']!)),
                          DataCell(Text(user['role']!)),
                          DataCell(Row(
                            children: [
                              // Promote button
                              ElevatedButton(
                                onPressed: () => _showMessage(context, '${user['name']} promoted'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red[700],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Promote'),
                              ),
                              const SizedBox(width: 8),

                              // Disable button
                              ElevatedButton(
                                onPressed: () => _showMessage(context, '${user['name']} disabled'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey[600],
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text('Disable'),
                              ),
                            ],
                          )),
                        ],
                      );
                    }).toList(), // Convert rows into list
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
            // Footer message
            const Center(
              child: Text(
                'Welcome to RedSpartanData Dashboard',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
