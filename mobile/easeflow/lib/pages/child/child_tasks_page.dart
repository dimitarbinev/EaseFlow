import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class ChildTasksPage extends StatelessWidget {
  final List<TaskModel> tasks;

  const ChildTasksPage({super.key, required this.tasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Tasks')),
      body: tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (_, index) {
                final task = tasks[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(task.title,
                        style: const TextStyle(fontSize: 20)),
                    subtitle: Text(task.description),
                    trailing: Icon(
                      task.completed
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.completed ? Colors.green : Colors.grey,
                      size: 30,
                    ),
                  ),
                );
              },
            ),
    );
  }
}