import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  final String userEmail;

  const ProfilePage({super.key, required this.userEmail});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> _userProfile;

  @override
  void initState() {
    super.initState();
    _userProfile = _fetchUserProfile();
  }

  Future<Map<String, dynamic>> _fetchUserProfile() async {
    final url = Uri.parse('http://192.168.56.1/redspartan_api/fetch_profile.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': widget.userEmail}),
    );

    final data = jsonDecode(response.body);
    if (data['success']) {
      return data['user'];
    } else {
      throw Exception(data['message'] ?? 'Failed to load profile.');
    }
  }

  void _changePasswordDialog() {
    final TextEditingController _currentPassword = TextEditingController();
    final TextEditingController _newPassword = TextEditingController();
    final TextEditingController _confirmPassword = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
              ),
            ),
            TextField(
              controller: _newPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
              ),
            ),
            TextField(
              controller: _confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: const Text('Update'),
            onPressed: () async {
              String current = _currentPassword.text.trim();
              String newPass = _newPassword.text.trim();
              String confirm = _confirmPassword.text.trim();

              if (newPass != confirm) {
                Navigator.pop(context);
                _showMessage('New passwords do not match.');
                return;
              }

              final url = Uri.parse('http://192.168.56.1/redspartan_api/update_password.php');
              final response = await http.post(
                url,
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'email': widget.userEmail,
                  'current_password': current,
                  'new_password': newPass,
                }),
              );

              final data = jsonDecode(response.body);
              Navigator.pop(context);

              _showMessage(data['message']);
            },
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _confirmLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<Map<String, dynamic>>(
        future: _userProfile,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red)),
            );
          }

          final user = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Profile Picture
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.red[100],
                    backgroundImage: const AssetImage('assets/images.png'),
                  ),
                ),
                const SizedBox(height: 16),

                // User Name
                Text(
                  '${user['name']} ${user['lastname']}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 20),

                // Profile Info Card
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        _buildInfoRow("Email", user['email']),
                        const Divider(),
                        _buildInfoRow("Position", user['position']),
                        const Divider(),
                        _buildInfoRow("Office", user['office']),
                        const Divider(),
                        _buildInfoRow("Campus", user['campus']),
                        const Divider(),
                        _buildInfoRow("Role", user['role']),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Change Password Button
                ElevatedButton.icon(
                  onPressed: _changePasswordDialog,
                  icon: const Icon(Icons.lock_reset),
                  label: const Text('Change Password'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Sign Out Button
                ElevatedButton.icon(
                  onPressed: _confirmLogout,
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
