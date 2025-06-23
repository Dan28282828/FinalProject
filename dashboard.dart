// Dhaven Jun A. Plata

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

// Root of the application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RedSpartanData',
      debugShowCheckedModeBanner: false,
      home: const DashboardPage(), // Sets DashboardPage as the home screen
    );
  }
}

// Stateless widget for DashboardPage
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  // Handles menu item selections
  void _handleMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile selected')));
        break;
      case 'activity':
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User Activity selected')));
        break;
      case 'manage':
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Manage Users selected')));
        break;
      case 'logout':
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged out')));
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[700], // Custom app bar color
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            // Logo image in circle shape
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/Spartan.jpg', // Make sure the image exists in the assets folder
                height: 40,
                width: 40,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            // Dashboard title
            const Text(
              'RedSpartanData',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const Spacer(),
            // Dropdown menu in the app bar
            PopupMenuButton<String>(
              icon: const Icon(Icons.menu, color: Colors.white),
              onSelected: (value) => _handleMenuSelection(context, value),
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'profile', child: Text('Profile')),
                const PopupMenuItem(value: 'activity', child: Text('User Activity')),
                const PopupMenuItem(value: 'manage', child: Text('Manage Users')),
                const PopupMenuItem(value: 'logout', child: Text('Logout')),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20), // Padding around the dashboard
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title text
            const Text(
              'Dashboard Overview',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Card widget displaying statistics and action buttons
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                child: Column(
                  children: [
                    // Statistics row (Total Users and Reports)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Column(
                          children: [
                            Text('Total Users', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('124', style: TextStyle(fontSize: 20, color: Colors.blue)),
                          ],
                        ),
                        Column(
                          children: [
                            Text('Total Reports', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            SizedBox(height: 8),
                            Text('36', style: TextStyle(fontSize: 20, color: Colors.green)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Action buttons row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            // Action for View Users button
                          },
                          icon: const Icon(Icons.people),
                          label: const Text('View Users'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            // Action for View Reports button
                          },
                          icon: const Icon(Icons.description),
                          label: const Text('View Reports'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[700],
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Welcome message at the bottom
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
