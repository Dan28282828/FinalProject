
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'dashboard.dart'; 

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Missing Fields', 'Please enter both email and password.');
      return;
    }

    try {
      final url = Uri.parse('http://192.168.56.1/login.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardPage(
              userEmail: data['user']['email'],
              userOffice: data['user']['office'],
              userRole: data['user']['role'],
            ),
          ),
        );
      } else {
        _showDialog('Login Failed', data['message']);
      }
    } catch (e) {
      _showDialog('Error', 'Could not connect to the server.');
    }
  }

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(title, style: TextStyle(color: Colors.redAccent)),
        content: Text(message, style: TextStyle(color: Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showForgotPasswordDialog() {
    final TextEditingController _resetEmailController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Forgot Password?', style: TextStyle(color: Colors.redAccent)),
        content: TextField(
          controller: _resetEmailController,
          decoration: InputDecoration(
            labelText: 'Enter your email',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text('Send'),
            onPressed: () {
              // You can call a reset API here
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Password reset link sent if email exists.')),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 50,
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: TextStyle(color: Colors.black),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: label,
          labelStyle: TextStyle(color: Colors.redAccent),
          prefixIcon: Icon(icon, color: Colors.redAccent),
          suffixIcon: suffix,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.redAccent),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red, width: 2),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('assets/logo.jpg'),
              ),
              SizedBox(height: 10),
              Text(
                'RedSpartanData',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 40),
              _buildTextField(
                label: 'Email',
                icon: Icons.email,
                controller: _emailController,
              ),
              _buildTextField(
                label: 'Password',
                icon: Icons.lock,
                controller: _passwordController,
                obscure: _obscureText,
                suffix: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off : Icons.visibility,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              SizedBox(height: 8),

              // 👇 Forgot Password Button
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.redAccent)),
                ),
              ),

              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 80, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
