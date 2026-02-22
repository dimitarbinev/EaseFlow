import 'package:flutter/material.dart';
import '../models/task_model.dart';

class CreateTaskPage extends StatefulWidget {
  final List<TaskModel> tasks; // receive the shared list

  const CreateTaskPage({super.key, required this.tasks});

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  final titleController = TextEditingController();
  final descController = TextEditingController();

  void _submitTask() {
    final title = titleController.text.trim();
    final desc = descController.text.trim();
    if (title.isEmpty) return;

    setState(() {
      widget.tasks.add(TaskModel(title: title, description: desc));
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task created!')),
    );

    titleController.clear();
    descController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Task')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitTask,
              child: const Text('Submit Task'),
            ),
          ],
        ),
      ),
    );
  }
}