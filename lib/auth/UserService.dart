import 'dart:convert';
import 'package:flutter/services.dart';

class UserService {
  // Load users from JSON
  static Future<List<dynamic>> loadUsers() async {
    final String response = await rootBundle.loadString('assets/data/projects_and_users.json');
    return json.decode(response)['users'];
  }

  // Load projects from JSON
  static Future<List<Map<String, dynamic>>> loadProjects() async {
  final String response = await rootBundle.loadString('assets/data/projects_and_users.json');
  final Map<String, dynamic> data = json.decode(response);
  return List<Map<String, dynamic>>.from(data['projects']);
}

}
