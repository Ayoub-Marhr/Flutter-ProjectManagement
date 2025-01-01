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
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        final project = projects[index];
        // Dynamically calculate progress
        int totalTasks = project['tasks'].length;
        int completedTasks = project['tasks']
            .where((task) => task['status'] == 'Completed')
            .length;
        double progress = totalTasks == 0 ? 0 : (completedTasks / totalTasks);

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
                          if (members.length > 2)
                            Text(
                              'And ${members.length - 2} more...',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
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
      },
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = Colors.grey[300]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;

    Paint progressPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    double center = size.width / 2;
    double radius = center - 8;

    canvas.drawCircle(Offset(center, center), radius, backgroundPaint);

    double angle = 2 * 3.14159265359 * progress;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(center, center), radius: radius),
      -3.14159265359 / 2,
      angle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}