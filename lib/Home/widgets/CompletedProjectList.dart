import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/ProjectDetailPage.dart'; // Import the new page

class CompletedProjectList extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final Map<String, String> userIdToFullName;  // Add this parameter

  const CompletedProjectList({
    Key? key,
    required this.projects,
    required this.userIdToFullName, // Add this parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: projects.length,
        itemBuilder: (context, index) {
          final project = projects[index];

          // Convert members to full names
          List<String> members = (project['members'] as List<dynamic>)
              .map((id) => userIdToFullName[id] ?? "Unknown User")
              .toList();

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SizedBox(
              width: 180,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProjectDetailPage(
                        project: project,
                        userIdToFullName: userIdToFullName,
                      ),
                    ),
                  );
                },
                child: Card(
                  color: Color(0xFF445B64),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        // Display members first
                        Text(
                          "Members: ${members.join(', ')}", // Join names for display
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10), // Space between members and due date
                        const Spacer(),
                        Text(
                          "Due on: ${project['date'] ?? ''}",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                          minHeight: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}