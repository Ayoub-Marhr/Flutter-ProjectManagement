import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/ProjectMembersPage.dart'; // Import the new page
import 'package:gestionprojet/ProjectDetails/AddTaskPage.dart'; // Import AddTaskPage

class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, String> userIdToFullName; // Map for user ID to full name mapping

  const ProjectDetailPage({
    Key? key,
    required this.project,
    required this.userIdToFullName, // Map that maps user IDs to full names
  }) : super(key: key);

  @override
  _ProjectDetailPageState createState() => _ProjectDetailPageState();
}

class _ProjectDetailPageState extends State<ProjectDetailPage> {
  late Map<String, dynamic> project;

  @override
  void initState() {
    super.initState();
    project = widget.project;
  }

  // Function to calculate project progress
  double calculateProgress() {
    int totalTasks = project['tasks'].length;
    int completedTasks = project['tasks'].where((task) => task['status'] == 'Completed').length;

    return (completedTasks / totalTasks) * 100;
  }

  // Function to get the full names of users assigned to a task
  List<String> getAssignedNames(List<dynamic> assignedTo) {
    List<String> names = [];
    for (var userId in assignedTo) {
      var userName = widget.userIdToFullName[userId];
      if (userName != null) {
        names.add(userName);
      }
    }
    return names;
  }

  // Function to refresh the tasks list after adding a task
  void _refreshProject(Map<String, dynamic> newTask) {
    setState(() {
      project['tasks'].add(newTask);
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress();
    List<String> members = List<String>.from(project['members'] ?? []);
    List<Map<String, dynamic>> tasks = List<Map<String, dynamic>>.from(project['tasks'] ?? []);

    // Extract project due date
    String projectDueDate = project['dueDate'] ?? 'No due date available';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Detail',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF202932), Color.fromARGB(255, 81, 96, 110)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFF202932),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Project Title Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project['title'] ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFfed36a),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.calendar_today,
                          color: Colors.black,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Due on: $projectDueDate',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFfed36a),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.people,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectMembersPage(
                                members: members,
                                projectTitle: project['title'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Project Members',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Project Details",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      project['description'] ?? 'Detailed project description goes here.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Project Progress",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Track your project completion",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black26,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomPaint(
                              size: const Size(80, 80),
                              painter: ProgressCirclePainter(progress: 1.0),
                            ),
                            CustomPaint(
                              size: const Size(80, 80),
                              painter: ProgressCirclePainter(progress: progress / 100),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '${progress.toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Tasks",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      // Convert user IDs to full names
                      List<String> assignedNames = getAssignedNames(tasks[index]['assignedTo']);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white12,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tasks[index]['title'] ?? 'No title',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Due: ${tasks[index]['dueDate'] ?? ''}",
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Assigned to: ${assignedNames.join(', ')}", // Join names for display
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: tasks[index]['status'] == 'Completed'
                                    ? Colors.green.withOpacity(0.3)
                                    : Colors.orange.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                tasks[index]['status'] ?? 'Unknown',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddTaskPage(
                              projectName: project['title'] ?? 'Unknown Project',
                              projectMembers: members,
                              onTaskAdded: _refreshProject,
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFFfed36a),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Text(
                        'Add Task',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressCirclePainter extends CustomPainter {
  final double progress;

  const ProgressCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Colors.grey;

    canvas.drawCircle(
      Offset(size.width / 2, size.height / 2),
      size.width / 2,
      paint,
    );

    paint
      ..color = Colors.yellow
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 12;

    final double angle = 2 * 3.14159265359 * progress;
    canvas.drawArc(
      Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2,
      ),
      -3.14159265359 / 2,
      angle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
