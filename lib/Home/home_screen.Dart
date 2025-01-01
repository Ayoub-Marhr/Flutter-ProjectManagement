import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/ProjectDetailPage.dart';
import 'package:gestionprojet/auth/UserService.dart';
import '../CreateProject/CreateProjectPage.dart'; // Corrected the import path
import 'widgets/CompletedProjectList.dart';
import 'widgets/OngoingProjectList.dart';

class HomeScreen extends StatefulWidget {
  final Map<String, dynamic> loggedInUser;

  const HomeScreen({Key? key, required this.loggedInUser}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> completedProjects = [];
  List<Map<String, dynamic>> ongoingProjects = [];
  List<Map<String, dynamic>> filteredCompletedProjects = [];
  List<Map<String, dynamic>> filteredOngoingProjects = [];
  Map<String, String> userIdToFullName = {};

  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String errorMessage = '';

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

  // Load projects and user data
  Future<void> _loadData() async {
    try {
      final users = await UserService.loadUsers();
      final projects = await UserService.loadProjects();

      userIdToFullName = {
        for (var user in users) user['id']: user['fullname'],
      };

      setState(() {
        completedProjects = projects
            .where((project) =>
                (project['members'] as List).contains(widget.loggedInUser['id']) &&
                project['status'] == 'Completed')
            .toList();

        ongoingProjects = projects
            .where((project) =>
                (project['members'] as List).contains(widget.loggedInUser['id']) &&
                project['status'] == 'Ongoing')
            .toList();

        filteredCompletedProjects = completedProjects;
        filteredOngoingProjects = ongoingProjects;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error loading data: $e";
        isLoading = false;
      });
    }
  }

  // Filter projects based on search query
  void _filterProjects() {
    String query = searchController.text.toLowerCase();

    setState(() {
      filteredCompletedProjects = completedProjects
          .where((project) => project['title'].toLowerCase().contains(query))
          .toList();

      filteredOngoingProjects = ongoingProjects
          .where((project) => project['title'].toLowerCase().contains(query))
          .toList();
    });
  }

  // Navigate to CreateProjectPage and handle the new project creation
  void _navigateToCreateProject() async {
    final newProject = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreateProjectPage()),
    );

    if (newProject != null) {
      setState(() {
        ongoingProjects.add(newProject);
        filteredOngoingProjects = List.from(ongoingProjects); // Update the filtered list
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF242D35),
      appBar: AppBar(
        title: Text(
          "Welcome, ${widget.loggedInUser['fullname']}",
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF202932),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            _buildSearchField(),
            const SizedBox(height: 20),
            _buildProjectSection("Completed Projects", filteredCompletedProjects),
            const SizedBox(height: 20),
            _buildProjectSection("Ongoing Projects", filteredOngoingProjects),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFED36A),
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: _navigateToCreateProject,
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white12,
        hintText: "Search tasks",
        hintStyle: const TextStyle(color: Colors.white54),
        prefixIcon: const Icon(Icons.search, color: Colors.white54),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildProjectSection(String title, List<Map<String, dynamic>> projects) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                // Add functionality for "See All" button
              },
              child: const Text(
                "See All",
                style: TextStyle(color: Color(0xFFFED36A)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        projects.isEmpty
            ? Text(
                "No projects available.",
                style: const TextStyle(color: Colors.white54, fontSize: 16),
              )
            : (title == "Completed Projects"
                ? CompletedProjectList(
                    projects: projects,
                    userIdToFullName: userIdToFullName,
                  )
                : OngoingProjectList(
                    projects: projects,
                    userIdToFullName: userIdToFullName,
                  )),
      ],
    );
  }
}
