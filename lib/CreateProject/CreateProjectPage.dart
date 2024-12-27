import 'package:flutter/material.dart';
import '../main.dart';

class Task {
  String title;
  String description;
  List<String> assignedMembers;
  bool isCompleted;
  bool isExpanded;

  Task({
    required this.title,
    this.description = '',
    this.assignedMembers = const [],
    this.isCompleted = false,
    this.isExpanded = false,
  });
}

class CreateProjectPage extends StatefulWidget {
  @override
  _CreateProjectPageState createState() => _CreateProjectPageState();
}

class _CreateProjectPageState extends State<CreateProjectPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _taskDescriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();
  List<String> selectedMembers = [];
  List<Task> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF202932),
      appBar: AppBar(
        backgroundColor: Color(0xFF202932),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
        title: Text(
          'Create New Project',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Project Title',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF2F3B46),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter project title',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 24),

            Text(
              'Project Details',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _detailsController,
              style: TextStyle(color: Colors.white),
              maxLines: 3,
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xFF2F3B46),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                hintText: 'Enter project details',
                hintStyle: TextStyle(color: Colors.white54),
              ),
            ),
            SizedBox(height: 24),

            Text(
              'Add team members',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: selectedMembers.map((member) => _buildMemberChip(member)).toList(),
            ),
            SizedBox(height: 16),
            IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF2F3B46),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, color: Color(0xFFFED36A), size: 20),
              ),
              onPressed: () {
                _showAddMemberDialog();
              },
            ),
            SizedBox(height: 24),

            Text(
              'Time & Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final TimeOfDay? time = await showTimePicker(
                        context: context,
                        initialTime: selectedTime,
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Color(0xFFFED36A),
                                onPrimary: Colors.black,
                                surface: Color(0xFF2F3B46),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (time != null) {
                        setState(() {
                          selectedTime = time;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2F3B46),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedTime.format(context)}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.access_time, color: Color(0xFFFED36A)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final DateTime? date = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2025),
                        builder: (BuildContext context, Widget? child) {
                          return Theme(
                            data: ThemeData.dark().copyWith(
                              colorScheme: ColorScheme.dark(
                                primary: Color(0xFFFED36A),
                                onPrimary: Colors.black,
                                surface: Color(0xFF2F3B46),
                                onSurface: Colors.white,
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (date != null) {
                        setState(() => selectedDate = date);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(0xFF2F3B46),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: TextStyle(color: Colors.white),
                          ),
                          Icon(Icons.calendar_today, color: Color(0xFFFED36A)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text(
              'Add New Task',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF2F3B46),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter task',
                      hintStyle: TextStyle(color: Colors.white54),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0xFF2F3B46),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Color(0xFFFED36A), size: 20),
                  ),
                  onPressed: () {
                    if (_taskController.text.isNotEmpty) {
                      setState(() {
                        tasks.add(Task(title: _taskController.text));
                        _taskController.clear();
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 16),

            if (tasks.isNotEmpty) ...[
              _buildTaskList(),
              SizedBox(height: 24),
            ],

            Container(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFFFED36A),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Create',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final descriptionController = TextEditingController(text: task.description);

        return Card(
          color: Color(0xFF2F3B46),
          margin: EdgeInsets.only(bottom: 8),
          child: ExpansionTile(
            leading: Checkbox(
              value: task.isCompleted,
              onChanged: (bool? value) {
                setState(() {
                  task.isCompleted = value ?? false;
                });
              },
              fillColor: MaterialStateProperty.resolveWith(
                (states) => Color(0xFFFED36A),
              ),
            ),
            title: Text(
              task.title,
              style: TextStyle(
                color: Colors.white,
                decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.white54),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: Color(0xFF2F3B46),
                    title: Text('Delete Task', style: TextStyle(color: Colors.white)),
                    content: Text('Are you sure you want to delete this task?',
                        style: TextStyle(color: Colors.white)),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel', style: TextStyle(color: Colors.white54)),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            tasks.removeAt(index);
                          });
                          Navigator.pop(context);
                        },
                        child: Text('Delete', style: TextStyle(color: Color(0xFFFED36A))),
                      ),
                    ],
                  ),
                );
              },
            ),
            children: [
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: descriptionController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Add description',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Color(0xFF202932),
                      ),
                      maxLines: 3,
                      onChanged: (value) {
                        setState(() {
                          task.description = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Assigned Members',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        ...task.assignedMembers.map((member) => Chip(
                              label: Text(member, style: TextStyle(color: Colors.white)),
                              backgroundColor: Color(0xFF202932),
                              deleteIcon: Icon(Icons.close, size: 18, color: Color(0xFFFED36A)),
                              onDeleted: () {
                                setState(() {
                                  task.assignedMembers.remove(member);
                                });
                              },
                            )),
                        ActionChip(
                          label: Icon(Icons.add, size: 20, color: Color(0xFFFED36A)),
                          backgroundColor: Color(0xFF202932),
                          onPressed: () => _showAssignMemberDialog(index),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMemberChip(String name) {
    return Chip(
      label: Text(
        name,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Color(0xFF2F3B46),
      deleteIcon: Icon(Icons.close, color: Color(0xFFFED36A)),
      onDeleted: () {
        setState(() {
          selectedMembers.remove(name);
        });
      },
    );
  }

  void _showAddMemberDialog() {
    final TextEditingController _memberController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF2F3B46),
          title: const Text(
            'Add Team Member',
            style: TextStyle(color: Colors.white),
          ),
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
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              onPressed: () {
                final memberName = _memberController.text.trim();
                if (memberName.isNotEmpty) {
                  setState(() {
                    selectedMembers.add(memberName);
                  });
                }
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFED36A),
              ),
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }


  void _showAssignMemberDialog(int taskIndex) {
    showDialog(
context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2F3B46),
          title: Text('Assign Members', style: TextStyle(color: Colors.white)),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: selectedMembers.length,
              itemBuilder: (context, index) {
                final member = selectedMembers[index];
                final isAssigned = tasks[taskIndex].assignedMembers.contains(member);
                return CheckboxListTile(
                  title: Text(member, style: TextStyle(color: Colors.white)),
                  value: isAssigned,
                  onChanged: (bool? value) {
                    setState(() {
                      if (value ?? false) {
                        if (!tasks[taskIndex].assignedMembers.contains(member)) {
                          tasks[taskIndex].assignedMembers.add(member);
                        }
                      } else {
                        tasks[taskIndex].assignedMembers.remove(member);
                      }
                    });
                    Navigator.pop(context);
                  },
                  activeColor: Color(0xFFFED36A),
                  checkColor: Colors.black,
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close', style: TextStyle(color: Color(0xFFFED36A))),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _detailsController.dispose();
    _taskController.dispose();
    _taskDescriptionController.dispose();
    super.dispose();
  }
}