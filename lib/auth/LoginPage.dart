import 'package:flutter/material.dart';
import 'package:gestionprojet/auth/SignUpPage.dart';
import 'package:gestionprojet/auth/UserService.dart';
import '../main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String errorMessage = '';

  void _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Email and password must not be empty";
      });
      return;
    }

    try {
      // Load users and projects from JSON
      final users = await UserService.loadUsers();
      final allProjects = await UserService.loadProjects();

      // Validate credentials
      final user = users.firstWhere(
        (user) => user['email'] == email && user['password'] == password,
        orElse: () => null,
      );

      if (user != null) {
        // Successful login, navigate to BaseScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BaseScreen(
              loggedInUser: user,
              allProjects: allProjects,
            ),
          ),
        );
      } else {
        setState(() {
          errorMessage = "Invalid email or password";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred while logging in";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202833),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Email Address",
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                prefixIcon: const Icon(Icons.email, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Password",
                labelStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFF1F1F1F),
                prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                suffixIcon: const Icon(Icons.visibility_off, color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            if (errorMessage.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                errorMessage,
                style: const TextStyle(color: Colors.red, fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFED36A),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Log in",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don’t have an account? ",
                  style: TextStyle(color: Colors.grey),
                ),
                TextButton(
  onPressed: () {
    // Navigate to SignUpPage
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SignUpPage(),
      ),
    );
  },
  child: const Text(
    "Sign Up",
    style: TextStyle(color: Color(0xFFFED36A)),
  ),
),

              ],
            ),
          ],
        ),
      ),
    );
  }
}
