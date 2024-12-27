import 'package:flutter/material.dart';
import 'package:gestionprojet/main.dart';

class ProfilePage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile', style: TextStyle(fontWeight: FontWeight.w500)),
        backgroundColor: Color(0xFF202833),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyApp()),
            );
          },
        ),
      ),
      body: Container(
        color: Color(0xFF202833),
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              EditableRow(
                icon: Icons.person,
                controller: nameController,
                hintText: 'Name',
              ),
              EditableRow(
                icon: Icons.email,
                controller: emailController,
                hintText: 'Email',
              ),
              EditableRow(
                icon: Icons.lock,
                controller: passwordController,
                hintText: 'Password',
                isPassword: true,
              ),
              SizedBox(height: 16.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProjectsPage()),
                  );
                },
                child: ProfileRow(
                  icon: Icons.task,
                  text: 'My Projects',
                  isDropdown: true,
                  backgroundColor: Color(0xFF37474F),
                ),
              ),
              SizedBox(height: 24.0),
              LogoutButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class EditableRow extends StatelessWidget {
  final IconData icon;
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;

  const EditableRow({
    required this.icon,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: Color(0xFF37474F),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 16.0),
          Expanded(
            child: TextFormField(
              controller: controller,
              obscureText: isPassword,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: Colors.grey[400]),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDropdown;
  final Color backgroundColor;

  const ProfileRow({
    required this.icon,
    required this.text,
    this.isDropdown = false,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 16.0),
              Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          if (isDropdown)
            Icon(Icons.arrow_drop_down, color: Colors.grey[400]),
        ],
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFFFD600),
        foregroundColor: Colors.black,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(
        'Logout',
        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class ProjectsPage extends StatelessWidget {
  final List<Map<String, String>> projects = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Projects'),
        backgroundColor: Color(0xFF202833),
      ),
      body: Container(
        color: Color(0xFF202833),
        padding: const EdgeInsets.all(16.0),
        child: projects.isNotEmpty
            ? ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(
                    projectName: projects[index]['name']!,
                    projectDetails: projects[index]['details']!,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProjectDetailsPage(
                            projectName: projects[index]['name']!,
                            projectDetails: projects[index]['details']!,
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            : Center(
                child: Text(
                  "No Projects Available",
                  style: TextStyle(color: Colors.white54, fontSize: 18),
                ),
              ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String projectName;
  final String projectDetails;
  final VoidCallback onTap;

  const ProjectCard({
    required this.projectName,
    required this.projectDetails,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Color(0xFF37474F),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              projectName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              projectDetails,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.0,
                height: 1.4,
              ),
            ),
            SizedBox(height: 8.0),
            Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProjectDetailsPage extends StatelessWidget {
  final String projectName;
  final String projectDetails;

  const ProjectDetailsPage({
    required this.projectName,
    required this.projectDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(projectName),
        backgroundColor: Color(0xFF202833),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          projectDetails,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
      ),
      backgroundColor: Color(0xFF202833),
    );
  }
}
