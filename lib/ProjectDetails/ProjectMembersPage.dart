import 'package:flutter/material.dart';

class ProjectMembersPage extends StatefulWidget {
  final List<String> members;
  final String projectTitle;

  const ProjectMembersPage({
    Key? key,
    required this.members,
    required this.projectTitle,
  }) : super(key: key);

  @override
  _ProjectMembersPageState createState() => _ProjectMembersPageState();
}

class _ProjectMembersPageState extends State<ProjectMembersPage> {
  TextEditingController searchController = TextEditingController();
  List<String> filteredMembers = [];
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    filteredMembers = widget.members; // Initially, show all members
    searchController.addListener(_filterMembers);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _filterMembers() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredMembers = widget.members
          .where((member) => member.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? TextField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Search members...',
                  hintStyle: const TextStyle(color: Colors.white54),
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                autofocus: true,
              )
            : const Text(
                'Project Members',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
        backgroundColor: const Color(0xFF202932),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(isSearching ? Icons.close : Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (isSearching) {
              setState(() {
                isSearching = false;
                searchController.clear();
              });
            } else {
              Navigator.pop(context);
            }
          },
        ),
        actions: [
          if (!isSearching)
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {
                setState(() {
                  isSearching = true;
                });
              },
            ),
        ],
      ),
      backgroundColor: const Color(0xFF202932),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Icon and Project Title
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFfed36a),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.person_outline,
                    size: 30,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.projectTitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Members List Section
            Expanded(
              child: filteredMembers.isNotEmpty
                  ? ListView.builder(
                      itemCount: filteredMembers.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                filteredMembers[index],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: index == 0 &&
                                      filteredMembers[index] == widget.members[0]
                                  ? const Text(
                                      'ADMIN',
                                      style: TextStyle(
                                        color: Color(0xFFfed36a),
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            const Divider(
                              color: Colors.white24,
                              thickness: 0.5,
                              height: 1,
                            ),
                          ],
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No members found',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
