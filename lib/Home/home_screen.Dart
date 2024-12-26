import 'package:flutter/material.dart';
import 'widgets/CompletedProjectList.dart';
import 'widgets/OngoingProjectList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> completedProjects = [
    {'title': 'Real Estate Website Design', 'date': '20 March'},
    {'title': 'Finance Mobile App Design', 'date': '15 April'},
  ];

  final List<Map<String, dynamic>> ongoingProjects = [
    {
      'title': 'Mobile App Wireframe',
      'date': '21 March',
      'progress': '0.5',
      'members': ['Alice', 'Bob']
    },
    {
      'title': 'Real Estate App Design',
      'date': '20 June',
      'progress': '0.3',
      'members': ['Charlie', 'David']
    },
    {
      'title': 'Dashboard & App Design',
      'date': '28 June',
      'progress': '0.8',
      'members': ['Eva', 'Frank']
    },
  ];

  TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredCompletedProjects = [];
  List<Map<String, dynamic>> filteredOngoingProjects = [];

  @override
  void initState() {
    super.initState();
    filteredCompletedProjects = completedProjects;
    filteredOngoingProjects = ongoingProjects;

    // Listen for changes in the search input and filter the lists
    searchController.addListener(_filterProjects);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterProjects() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredCompletedProjects = completedProjects
          .where((project) => project['title']!.toLowerCase().contains(query))
          .toList();

      filteredOngoingProjects = ongoingProjects
          .where((project) => project['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF242D35), // Secondary color
      appBar: AppBar(
        title: const Text("Home Screen",style: TextStyle(color: Colors.white),),
        backgroundColor: Color(0xFF242D35), // Secondary color
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Text(
              "Mahrhani Ayoub",
              style: TextStyle(
                color: Color(0xFFE4C677),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white12,
                hintText: "Search tasks",
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Completed Projects Section
            _sectionHeader("Completed Projects", onTap: () {
              // Action for 'See all'
            }),
            const SizedBox(height: 10),
            CompletedProjectList(projects: filteredCompletedProjects), // Display filtered list

            const SizedBox(height: 20),

            // Ongoing Projects Section
            _sectionHeader("Ongoing Projects", onTap: () {
              // Action for 'See all'
            }),
            const SizedBox(height: 10),
            OngoingProjectList(projects: filteredOngoingProjects), // Display filtered list
          ],
        ),
      ),
      
    );
  }

  Widget _sectionHeader(String title, {required VoidCallback onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            "See all",
            style: TextStyle(
              color: Color(0xFFE4C677), // Primary color
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
