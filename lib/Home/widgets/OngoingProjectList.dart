import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/ProjectDetailPage.dart'; // Import the new page

class OngoingProjectList extends StatelessWidget {
  final List<Map<String, dynamic>> projects;
  final Map<String, String> userIdToFullName;

  const OngoingProjectList({
    Key? key,
    required this.projects,
    required this.userIdToFullName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: projects.map((project) {
        // Safely parse progress value or default to 0 if invalid
        double progress = double.tryParse(project['progress']?.toString() ?? '0') ?? 0;

        // Convert members to full names
        List<String> members = (project['members'] as List<dynamic>)
            .map((id) => userIdToFullName[id] ?? "Unknown User")
            .toList();

        return InkWell(
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
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: Card(
              color: const Color(0xFF445B64),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            project['title'] ?? 'No title', 
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // Display first two members by full names
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: members.take(2).map((member) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(
                                  member,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          if (members.length > 2) ...[
                            Text(
                              'And ${members.length - 2} more...',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Text(
                            "Due on: ${project['date'] ?? ''}",
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: ProgressCirclePainter(progress: 1.0),
                          ),
                          CustomPaint(
                            size: const Size(80, 80),
                            painter: ProgressCirclePainter(progress: progress),
                          ),
                          Text(
                            '${(progress * 100).toStringAsFixed(0)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
