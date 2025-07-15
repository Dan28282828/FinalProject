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
  bool _agreedToTerms = false;

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showDialog('Missing Fields', 'Please enter both email and password.');
      return;
    }

    try {
      final url = Uri.parse('http://192.168.56.1/redspartan_api/login.php');
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

  void _sendResetLink(String email) async {
    if (email.isEmpty) {
      _showDialog('Error', 'Please enter an email address.');
      return;
    }

    try {
      final url = Uri.parse('http://192.168.56.1/redspartan_api/forgot_password.php');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (data['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reset link sent to your email.')),
        );
      } else {
        _showDialog('Failed', data['message']);
      }
    } catch (e) {
      _showDialog('Error', 'Unable to send request. Please try again later.');
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
              Navigator.pop(context);
              _sendResetLink(_resetEmailController.text.trim());
            },
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Terms and Conditions'),
        content: SingleChildScrollView(
          child: Text(
            'By using this app, you agree to:\n\n'
            '- Provide accurate and truthful information\n'
            '- Keep your login credentials confidential\n'
            '- Follow your institution’s data privacy and reporting policies\n'
            '- Misuse may result in account suspension or data removal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: Colors.redAccent)),
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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _showForgotPasswordDialog,
                  child: Text('Forgot Password?', style: TextStyle(color: Colors.redAccent)),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    activeColor: Colors.redAccent,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _showTermsDialog,
                      child: Text.rich(
                        TextSpan(
                          text: 'I agree to the ',
                          style: TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Terms and Conditions',
                              style: TextStyle(
                                color: Colors.redAccent,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _agreedToTerms ? _login : null,
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
