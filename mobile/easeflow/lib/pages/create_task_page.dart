import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import '../models/task_model.dart';
import '../widgets/app_scaffold.dart';

class CreateTaskPage extends StatefulWidget {
  final List<TaskModel> tasks;

  const CreateTaskPage({super.key, required this.tasks});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final titleController = TextEditingController();
  final childUidController = TextEditingController();

  bool _loading = false;

  final String baseUrl =
      'https://jamie-subsatirical-abbreviatedly.ngrok-free.dev/tasks/';

  Future<void> _submitTask() async {
    if (_loading) return; // 🔥 prevent double tap

    final title = titleController.text.trim();
    final childUid = childUidController.text.trim();

    if (title.isEmpty || childUid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      // 🔐 1. Get Firebase token (SAFE)
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception("User not authenticated");

      final idToken = await user.getIdToken();

      // 🌐 2. Send request WITH TIMEOUT (important for lag)
      final response = await http
          .post(
            Uri.parse(baseUrl),
            headers: {
              "Authorization": "Bearer $idToken",
              "Content-Type": "application/json",
            },
            body: jsonEncode({
              "title": title,
              "userId": childUid,
              "childUid": childUid,
            }),
          )
          .timeout(const Duration(seconds: 15));

      if (!mounted) return;

      // 🚨 Check content type FIRST
      final contentType = response.headers['content-type'] ?? '';
      if (!contentType.contains('application/json')) {
        throw Exception(
          "Backend returned non-JSON.\nStatus: ${response.statusCode}",
        );
      }

      // ✅ Success
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          widget.tasks.add(
            TaskModel(
              title: title,
              childUid: childUid,
            ),
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created!')),
        );

        titleController.clear();
        childUidController.clear();
      } else {
        final result = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'] ?? 'Failed to create task')),
        );
      }
    } on TimeoutException {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Request timeout — backend slow')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Create task error: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    childUidController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.title, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: childUidController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Child ID',
                labelStyle: const TextStyle(color: Colors.white70),
                prefixIcon: const Icon(Icons.person, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 48,
              child: _loading
                  ? const Center(child: CircularProgressIndicator(color: Colors.teal))
                  : ElevatedButton(
                      onPressed: _submitTask,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Submit Task'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}