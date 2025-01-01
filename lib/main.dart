import 'package:flutter/material.dart';
import 'package:gestionprojet/CreateProject/CreateProjectPage.dart';
import 'package:gestionprojet/Home/home_screen.dart';
import 'package:gestionprojet/Schedule/Schedule.dart';
import 'package:gestionprojet/auth/LoginPage.dart';
import 'package:gestionprojet/profil/SettingsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Start with LoginPage
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF202932),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF202932),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class BaseScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUser;
  final List<Map<String, dynamic>> allProjects; // Include projects data

  const BaseScreen({
    Key? key,
    required this.loggedInUser,
    required this.allProjects,
  }) : super(key: key);

  @override
  _BaseScreenState createState() => _BaseScreenState();
}

class _BaseScreenState extends State<BaseScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens dynamically with logged-in user and projects data
    _screens = [
      HomeScreen(loggedInUser: widget.loggedInUser),
      CreateProjectPage(),
      SchedulePage(),
      ProfilePage(
        loggedInUser: widget.loggedInUser,
      ),
    ];
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFF202932),
        selectedItemColor: const Color(0xFFFED36A),
        unselectedItemColor: Colors.white54,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Project',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}