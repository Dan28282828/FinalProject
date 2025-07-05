import 'package:flutter/material.dart';
import 'create_campus_population_report.dart';
import 'profile_page.dart';
import 'report_history_page.dart';

class DashboardPage extends StatefulWidget {
  final String userEmail;
  final String userOffice;
  final String userRole;

  const DashboardPage({
    Key? key,
    required this.userEmail,
    required this.userOffice,
    required this.userRole,
  }) : super(key: key);

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _openCreateReport() {
    Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => CreateCampusPopulationReport(
      userEmail: widget.userEmail,
      userOffice: widget.userOffice,
    ),
  ),
);

  }

  Widget _buildHomePage() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome, ${widget.userEmail}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'This app allows BSU faculty to submit reports easily. Only admins and authorized faculty can access all features.',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: ElevatedButton(
              onPressed: _openCreateReport,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Create Report', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomePage(),
      ReportHistoryPage(
        userEmail: widget.userEmail,
      ),
      ProfilePage(userEmail: widget.userEmail),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            color: Colors.redAccent,
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage('assets/logo.jpg'),
                ),
                SizedBox(width: 12),
                Text(
                  'Spartan Data',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: pages[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black54,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
