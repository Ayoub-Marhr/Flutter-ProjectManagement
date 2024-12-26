import 'package:flutter/material.dart';

class ProjectCard extends StatelessWidget {
  final String title;
  final String date;
  final double? progress;
  final bool isOngoing;

  ProjectCard({
    required this.title,
    required this.date,
    this.progress,
    required this.isOngoing,
  });

  static Widget buildProjectList(List<Map<String, String>> projects, {required bool isOngoing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: projects.map((project) {
        double? progress = isOngoing ? double.parse(project['progress']!) : null;
        return Container(
          margin: const EdgeInsets.only(right: 12),
          width: 180,
          child: Card(
            color: Colors.white12,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title']!,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Due on: ${project['date']}",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  isOngoing
                      ? CircularProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                          strokeWidth: 6,
                        )
                      : LinearProgressIndicator(
                          value: 1.0,
                          backgroundColor: Colors.white30,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                        ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 180,
      child: Card(
        color: Colors.white12,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Due on: $date",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 10),
              isOngoing
                  ? CircularProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                      strokeWidth: 6,
                    )
                  : LinearProgressIndicator(
                      value: 1.0,
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
