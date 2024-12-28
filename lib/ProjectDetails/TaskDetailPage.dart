import 'package:flutter/material.dart';

class TaskDetailPage extends StatelessWidget {
  final Map<String, dynamic> task;
  final Map<String, String> userIdToFullName;
  final Function(String) onStatusChanged;

  const TaskDetailPage({
    Key? key,
    required this.task,
    required this.userIdToFullName,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Handle both List and String for `assignedTo`
    List<String> assignedUsers = [];
    if (task['assignedTo'] is List) {
      assignedUsers = (task['assignedTo'] as List<dynamic>)
          .map((userId) => userIdToFullName[userId] ?? 'Unknown User')
          .toList();
    } else if (task['assignedTo'] is String) {
      assignedUsers = [userIdToFullName[task['assignedTo']] ?? 'Unknown User'];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Task Details',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and Deadline in the Same Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Task Title
                Expanded(
                  child: Text(
                    task['title'] ?? 'No Title',
                    style: const TextStyle(
                      color: Color(0xFFFED36A), // Yellow accent
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Deadline
                if (task['dueDate'] != null)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFED36A), // Yellow accent
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "Due: ${task['dueDate']}",
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 20),

            // Task Description Section
            const Text(
              'Description',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF2D3B45),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                task['description'] ?? 'No description provided.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Assigned Users Section
            const Text(
              'Assigned Users',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Divider(
              color: const Color(0xFFFED36A),
              thickness: 2,
              endIndent: 16,
            ),
            const SizedBox(height: 8),
            ...assignedUsers.map((user) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    user,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                )),
            const SizedBox(height: 20),

            // Task Status Section with a Yellow Dropdown Border
            const Text(
              'Status',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2D3B45),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFFED36A), width: 1.5),
              ),
              child: DropdownButtonFormField<String>(
                value: ['Ongoing', 'Completed'].contains(task['status'])
                    ? task['status']
                    : 'Ongoing', // Fallback to 'Ongoing' if the status is invalid
                dropdownColor: const Color(0xFF2D3B45),
                items: ['Ongoing', 'Completed']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(
                            status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ))
                    .toList(),
                onChanged: (newStatus) {
                  if (newStatus != null) {
                    onStatusChanged(newStatus);
                    Navigator.pop(context);
                  }
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
