import 'package:flutter/material.dart';
import 'package:gestionprojet/main.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  List<Map<String, String>> tasks = [
    {'title': 'User Interviews', 'time': '09:00 - 10:30'},
    {'title': 'Wireframe', 'time': '10:30 - 12:30'},
    {'title': 'Icons', 'time': '14:00 - 15:00'},
    {'title': 'Mockups', 'time': '15:00 - 16:30'},
    {'title': 'Testing', 'time': '16:30 - 17:30'},
  ];

  DateTime selectedDate = DateTime.now();
  late List<DateTime> allDaysInYear;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    selectedDate = DateTime.now();
    allDaysInYear = _generateAllDaysInYear();

    // Scroll to today's date when the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  List<DateTime> _generateAllDaysInYear() {
    final List<DateTime> days = [];
    final DateTime now = DateTime.now();
    for (int month = 1; month <= 12; month++) {
      final DateTime firstDayOfMonth = DateTime(now.year, month, 1);
      final int daysInMonth = DateTime(now.year, month + 1, 0).day;
      for (int day = 1; day <= daysInMonth; day++) {
        days.add(DateTime(now.year, month, day));
      }
    }
    return days;
  }

  void _scrollToToday() {
    // Find the index of today's date in the list
    final index = allDaysInYear.indexWhere((day) =>
        day.year == selectedDate.year &&
        day.month == selectedDate.month &&
        day.day == selectedDate.day);

    if (index != -1) {
      // Scroll to today's date position
      _scrollController.animateTo(
        index * 48.0, // Assume each day takes about 48.0 pixels of width
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202932),
      appBar: AppBar(
        backgroundColor: const Color(0xFF202932),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () =>  Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            ),
        ),
        title: const Text(
          'Schedule',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              _showAddTaskDialog(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display Month and Year
              Text(
                DateFormat('MMMM yyyy').format(selectedDate),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              // Calendar Week Row with Horizontal Scrolling
              Container(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  controller: _scrollController, // Add the controller
                  itemCount: allDaysInYear.length,
                  itemBuilder: (context, index) {
                    final day = allDaysInYear[index];
                    final isSelected = day.isAtSameMomentAs(selectedDate);
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildDayColumn(
                        day.day.toString(),
                        ['S', 'M', 'T', 'W', 'T', 'F', 'S'][day.weekday % 7],
                        isSelected,
                        () {
                          setState(() {
                            selectedDate = day;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                "Today's Tasks",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: tasks
                    .map((task) => _buildTaskItem(task['title']!, task['time']!))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDayColumn(String date, String day, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFED36A) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              date,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              day,
              style: TextStyle(
                color: isSelected ? Colors.black : Colors.white54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(String title, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2F3B46),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFFED36A),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    String title = '';
    String time = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                onChanged: (value) {
                  time = value;
                },
                decoration: const InputDecoration(labelText: 'Time'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (title.isNotEmpty && time.isNotEmpty) {
                }
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
