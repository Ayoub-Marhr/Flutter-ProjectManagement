import 'package:flutter/material.dart';

class Task {
  String title;
  String description;
  List<String> assignedMembers;
  bool isCompleted;

  Task({
    required this.title,
    this.description = '',
    this.assignedMembers = const [],
    this.isCompleted = false,
  });
}

class CreateProjectPage extends StatefulWidget {
  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final List<String> selectedMembers = [];
  final List<Task> tasks = [];
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202932),
      appBar: AppBar(
        backgroundColor: Color(0xFF202932),
        title: const Text('Create New Project',
            style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Project Title'),
            _buildTextField(_titleController, 'Enter project title'),
            const SizedBox(height: 24),

            _buildSectionTitle('Project Details'),
            _buildTextField(_detailsController, 'Enter project details', maxLines: 3),
            const SizedBox(height: 24),

            _buildSectionTitle('Select Deadline'),
            _buildDateSelector(),
            const SizedBox(height: 24),

            _buildSectionTitle('Add Team Members'),
            _buildMemberList(),
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFFFED36A)),
              onPressed: _showAddMemberDialog,
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Tasks'),
            _buildTaskList(),
            _buildAddTaskButton(),

            const SizedBox(height: 24),
            _buildCreateProjectButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF2F3B46),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white54),
      ),
    );
  }

  Widget _buildDateSelector() {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
        style: const TextStyle(color: Colors.white),
      ),
      trailing: const Icon(Icons.calendar_today, color: Color(0xFFFED36A)),
      onTap: () async {
        final DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() => selectedDate = pickedDate);
        }
      },
    );
  }

  Widget _buildMemberList() {
    return Wrap(
      spacing: 8,
      children: selectedMembers
          .map(
            (member) => Chip(
              label: Text(member, style: const TextStyle(color: Colors.white)),
              backgroundColor: const Color(0xFF2F3B46),
              deleteIcon: const Icon(Icons.close, color: Color(0xFFFED36A)),
              onDeleted: () {
                setState(() => selectedMembers.remove(member));
              },
            ),
          )
          .toList(),
    );
  }

  Widget _buildTaskList() {
    return Column(
      children: tasks
          .map(
            (task) => Card(
              color: const Color(0xFF2F3B46),
              child: ListTile(
                title: Text(task.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(task.description,
                    style: const TextStyle(color: Colors.white70)),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white54),
                  onPressed: () => setState(() => tasks.remove(task)),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildAddTaskButton() {
    final TextEditingController _taskTitleController = TextEditingController();
    final TextEditingController _taskDescriptionController = TextEditingController();

    return ElevatedButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFF2F3B46),
            title: const Text('Add New Task', style: TextStyle(color: Colors.white)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _taskTitleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2F3B46),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter task title',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _taskDescriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF2F3B46),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter task description',
                    hintStyle: const TextStyle(color: Colors.white54),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    tasks.add(Task(
                      title: _taskTitleController.text,
                      description: _taskDescriptionController.text,
                    ));
                  });
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFED36A),
                ),
                child: const Text('Add', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFED36A),
      ),
      child: const Text('Add Task', style: TextStyle(color: Colors.black)),
    );
  }

  Widget _buildCreateProjectButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_titleController.text.isNotEmpty &&
              _detailsController.text.isNotEmpty) {
            final newProject = {
              'title': _titleController.text,
              'details': _detailsController.text,
              'deadline': '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
              'members': selectedMembers,
              'tasks': tasks.map((task) => {
                'title': task.title,
                'description': task.description,
                'status': task.isCompleted ? 'Completed' : 'Pending',
                'assignedMembers': task.assignedMembers,
              }).toList(),
            };
            Navigator.pop(context, newProject);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill in all fields'),
              ),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFED36A),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text('Create Project',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
    );
  }

  void _showAddMemberDialog() {
    final TextEditingController _memberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2F3B46),
        title: const Text('Add Member', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: _memberController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF2F3B46),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            hintText: 'Enter member name',
            hintStyle: const TextStyle(color: Colors.white54),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              if (_memberController.text.isNotEmpty) {
                setState(() => selectedMembers.add(_memberController.text));
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid name')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFED36A),
            ),
            child: const Text('Add', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    super.dispose();
  }
}
