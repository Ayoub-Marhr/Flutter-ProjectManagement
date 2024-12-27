import 'package:flutter/material.dart';

class AddTaskPage extends StatefulWidget {
  final String projectName;
  final List<String> projectMembers; // List of user full names
  final Function(Map<String, dynamic>) onTaskAdded;

  const AddTaskPage({
    Key? key,
    required this.projectName,
    required this.projectMembers,
    required this.onTaskAdded,
  }) : super(key: key);

  @override
  _AddTaskPageState createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _taskTitleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _dueDate;
  String _selectedStatus = 'Pending';
  String? _assignedTo;  // Single selected user for the task

  final List<String> taskStatuses = ['Pending', 'In Progress', 'Completed'];
  bool _isLoading = false;

  @override
  void dispose() {
    _taskTitleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_assignedTo == null) {
        // If no user is assigned, show an error
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please assign a task to a person')),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      // Simulate adding the task
      Map<String, dynamic> newTask = {
        'title': _taskTitleController.text,
        'description': _descriptionController.text,
        'dueDate': _dueDate?.toLocal().toString() ?? 'No due date',
        'status': _selectedStatus,
        'assignedTo': [_assignedTo], // Single user in a list
      };

      // Call the callback function to notify the parent (ProjectDetailPage)
      widget.onTaskAdded(newTask);

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Added Successfully')),
      );

      // After task added, navigate back to the previous page
      Navigator.pop(context);
    }
  }

  Future<void> _selectDueDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.black,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: const Color(0xFFFED36A),
        ),
      ),
      backgroundColor: const Color(0xFF202932),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildDropdown('Task Status', taskStatuses, _selectedStatus, (value) {
                  setState(() {
                    _selectedStatus = value!;
                  });
                }),
                const SizedBox(height: 24),
                _buildTextField(_taskTitleController, 'Task Title', 'Please enter task title'),
                const SizedBox(height: 24),
                _buildTextField(_descriptionController, 'Description', 'Please enter description'),
                const SizedBox(height: 24),
                _buildDueDateField(),
                const SizedBox(height: 24),
                _buildUserAssignmentDropdown(),  // Dropdown for assigning user
                const SizedBox(height: 24),
                _buildSubmitButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((status) => DropdownMenuItem<String>(
                    value: status,
                    child: Text(
                      status,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, String validationMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white),
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return validationMessage;
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDueDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Due Date',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _selectDueDate(context),
          child: AbsorbPointer(
            child: TextFormField(
              decoration: InputDecoration(
                labelText: _dueDate == null
                    ? 'Select Due Date'
                    : _dueDate!.toLocal().toString(),
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserAssignmentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assign to',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _assignedTo,
          items: widget.projectMembers
              .map((member) => DropdownMenuItem<String>(
                    value: member,
                    child: Text(
                      member,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _assignedTo = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Center(
      child: SizedBox(
        width: double.infinity,
        child: TextButton(
          onPressed: _isLoading ? null : _submitForm,
          style: TextButton.styleFrom(
            backgroundColor: const Color(0xFFFED36A),
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: _isLoading
              ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : const Text(
                  'Submit Task',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
