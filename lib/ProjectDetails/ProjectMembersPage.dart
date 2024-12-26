import 'package:flutter/material.dart';

class ProjectMembersPage extends StatelessWidget {
  final List<String> members;
  final String projectTitle;

  const ProjectMembersPage({
    Key? key,
    required this.members,
    required this.projectTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Members'),
        centerTitle: true,
        backgroundColor: Colors.white12,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFF202932),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Project Icon Section
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
                          const SizedBox(width: 10), // Space between icon and text
                          GestureDetector(
                            onTap: () {
                              // Navigate to ProjectMembersPage when tapped
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProjectMembersPage(members: members, projectTitle: '',),
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
              const SizedBox(height: 20),

              // Members List Section
              const Text(
                "Members",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      members[index],
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
