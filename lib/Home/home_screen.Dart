import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/ProjectDetailPage.dart';
import 'package:gestionprojet/auth/UserService.dart';
import 'widgets/CompletedProjectList.dart';
import 'widgets/OngoingProjectList.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> completedProjects = [];
  List<Map<String, dynamic>> ongoingProjects = [];
  List<Map<String, dynamic>> filteredCompletedProjects = [];
  List<Map<String, dynamic>> filteredOngoingProjects = [];

  Map<String, String> userIdToFullName = {}; // This will store the mapping of user IDs to full names
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
    searchController.addListener(_filterProjects);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Function to load the data
  void _loadData() async {
    try {
      final users = await UserService.loadUsers();
      final projects = await UserService.loadProjects();

      // Create a map to map user IDs to full names
      userIdToFullName = {
        for (var user in users) user['id']: user['fullname'],
      };

      setState(() {
        completedProjects = projects
            .where((project) => project['status'] == 'Completed')
            .toList();

        ongoingProjects = projects
            .where((project) => project['status'] == 'Ongoing')
            .toList();

        filteredCompletedProjects = completedProjects;
        filteredOngoingProjects = ongoingProjects;
      });
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  // Function to filter the projects
  void _filterProjects() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredCompletedProjects = completedProjects
          .where((project) =>
              project['title']!.toLowerCase().contains(query))
          .toList();

      filteredOngoingProjects = ongoingProjects
          .where((project) =>
              project['title']!.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the first user in the userIdToFullName map for greeting
    String firstUserFullName = userIdToFullName.values.isNotEmpty
        ? userIdToFullName.values.first
        : "User";

    return Scaffold(
      backgroundColor: Color(0xFF242D35),
      appBar: AppBar(
        title: const Text(
          "Home Screen",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF242D35),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with the first user's full name
            Text(
              ' $firstUserFullName', 
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
            _sectionHeader("Completed Projects", onTap: () {}),
            const SizedBox(height: 10),
            // Pass userIdToFullName map to CompletedProjectList
            CompletedProjectList(
              projects: filteredCompletedProjects,
              userIdToFullName: userIdToFullName, // Pass the map here
            ),

            const SizedBox(height: 20),

            // Ongoing Projects Section
            _sectionHeader("Ongoing Projects", onTap: () {}),
            const SizedBox(height: 10),
            // Pass userIdToFullName map to OngoingProjectList
            OngoingProjectList(
              projects: filteredOngoingProjects,
              userIdToFullName: userIdToFullName, // Pass the map here
            ),
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
              color: Color(0xFFE4C677),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
