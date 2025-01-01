import 'package:flutter/material.dart';
import 'package:gestionprojet/auth/UserService.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> loggedInUser;

  const ProfilePage({
    Key? key,
    required this.loggedInUser,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late List<Map<String, dynamic>> userProjects = [];

  @override
  void initState() {
    super.initState();
    _loadUserProjects();
  }

  Future<void> _loadUserProjects() async {
    try {
      final allProjects = await UserService.loadProjects();
      setState(() {
        userProjects = allProjects.where((project) {
          final members = project['members'] as List<dynamic>;
          return members.contains(widget.loggedInUser['id']);
        }).toList();
      });
    } catch (e) {
      debugPrint("Error loading user projects: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController =
        TextEditingController(text: widget.loggedInUser['fullname'] ?? '');
    final TextEditingController emailController =
        TextEditingController(text: widget.loggedInUser['email'] ?? '');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: const Color(0xFF202833),
      ),
      body: Container(
        color: const Color(0xFF202833),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            EditableRow(
              icon: Icons.person,
              controller: nameController,
              hintText: 'Name',
            ),
            EditableRow(
              icon: Icons.email,
              controller: emailController,
              hintText: 'Email',
            ),
            const SizedBox(height: 16.0),
            const Text(
              "My Projects",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: userProjects.isNotEmpty
                  ? ListView.builder(
                      itemCount: userProjects.length,
                      itemBuilder: (context, index) {
                        final project = userProjects[index];
                        return ProjectCard(
                          projectName: project['title'] ?? 'Unnamed Project',
                          projectDetails: project['description'] ?? 'No details available',
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "No Projects Available",
                        style: TextStyle(color: Colors.white54, fontSize: 18),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class EditableRow extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hintText;

  const EditableRow({
    required this.icon,
    required this.controller,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF37474F),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String projectDetails;

  const ProjectCard({
    required this.projectName,
    required this.projectDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFF37474F),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            projectName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            projectDetails,
            style: const TextStyle(color: Colors.white70, fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}
