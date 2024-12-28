import 'package:flutter/material.dart';
import 'package:gestionprojet/ProjectDetails/TaskDetailPage.dart';
import 'package:gestionprojet/ProjectDetails/ProjectMembersPage.dart';
import 'package:gestionprojet/ProjectDetails/AddTaskPage.dart';

class ProjectDetailPage extends StatefulWidget {
  final Map<String, dynamic> project;
  final Map<String, String> userIdToFullName;

  const ProjectDetailPage({
    Key? key,
    required this.project,
    required this.userIdToFullName,
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

  double calculateProgress() {
    int totalTasks = project['tasks'].length;
    int completedTasks =
        project['tasks'].where((task) => task['status'] == 'Completed').length;

    return (totalTasks == 0) ? 0 : (completedTasks / totalTasks) * 100;
  }

  void _updateTaskStatus(int taskIndex, String newStatus) {
    setState(() {
      project['tasks'][taskIndex]['status'] = newStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    double progress = calculateProgress() / 100; // Convert to percentage for progress indicator
    List<Map<String, dynamic>> tasks =
        List<Map<String, dynamic>>.from(project['tasks'] ?? []);

    // Convert member IDs to full names
    List<String> members = (project['members'] as List<dynamic>)
        .map((id) => widget.userIdToFullName[id] ?? 'Unknown User')
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Project Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF202932),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFF202932),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70.0), // Leave space for the button
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Project Title
                    Text(
                      project['title'] ?? 'No Title',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: const Color(0xFFfed36a)),
                        const SizedBox(width: 8),
                        Text(
                          'Due Date: ${project['dueDate'] ?? 'No due date'}',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProjectMembersPage(
                                  members: members, // Pass full names directly
                                  projectTitle: project['title'] ?? '',
                                ),
                              ),
                            );
                          },
                          child: Row(
                            children: const [
                              Icon(Icons.people, color: Color(0xFFfed36a)),
                              SizedBox(width: 8),
                              Text(
                                "Project Members",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Project Details",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      project['description'] ?? 'No description provided.',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Project Progress",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 60,
                              height: 60,
                              child: CircularProgressIndicator(
                                value: progress,
                                color: const Color(0xFFfed36a),
                                backgroundColor: Colors.white12,
                                strokeWidth: 6,
                              ),
                            ),
                            Text(
                              '${(progress * 100).toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "All Tasks",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TaskDetailPage(
                                  task: task,
                                  userIdToFullName: widget.userIdToFullName,
                                  onStatusChanged: (newStatus) {
                                    _updateTaskStatus(index, newStatus);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2D3B45),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  task['title'] ?? 'No Title',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                                DropdownButton<String>(
  value: ['Ongoing', 'Completed'].contains(task['status'])
      ? task['status']
      : 'Ongoing', // Fallback to 'Ongoing' if the status is invalid
  dropdownColor: const Color(0xFF202932),
  items: ['Ongoing', 'Completed']
      .map((status) => DropdownMenuItem(
            value: status,
            child: Text(
              status,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ))
      .toList(),
  onChanged: (newStatus) {
    if (newStatus != null) {
      _updateTaskStatus(index, newStatus);
    }
  },
),

                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Fixed Add Task Button
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: SizedBox(
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddTaskPage(
                        projectName: project['title'] ?? 'Unknown Project',
                        projectMembers: members, // Pass members for assignment
                        onTaskAdded: (task) {
                          setState(() {
                            project['tasks'].add(task);
                          });
                        },
                      ),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFfed36a),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Add Task",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
