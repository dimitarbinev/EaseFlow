import 'package:flutter/material.dart';
import '../../models/task_model.dart';

class ManageTasksPage extends StatefulWidget {
  final List<TaskModel> tasks;

  const ManageTasksPage({super.key, required this.tasks});

  @override
  State<ManageTasksPage> createState() => _ManageTasksPageState();
}

class _ManageTasksPageState extends State<ManageTasksPage> {
  void _addTask(String title, String description) {
    setState(() {
      widget.tasks.add(TaskModel(title: title, description: description));
    });
  }

  Future<void> _showCreateTaskDialog() async {
    final titleController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create Task'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _addTask(titleController.text, descController.text);
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Tasks')),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateTaskDialog,
        child: const Icon(Icons.add),
      ),
      body: widget.tasks.isEmpty
          ? const Center(child: Text('No tasks yet'))
          : ListView.builder(
              itemCount: widget.tasks.length,
              itemBuilder: (_, index) {
                final task = widget.tasks[index];
                return ListTile(
                  title: Text(task.title),
                  subtitle: Text(task.description),
                  trailing: Checkbox(
                    value: task.completed,
                    onChanged: (val) {
                      setState(() {
                        task.completed = val ?? false;
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}