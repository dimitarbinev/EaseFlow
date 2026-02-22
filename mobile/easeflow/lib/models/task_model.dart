// lib/models/task_model.dart
class TaskModel {
  final String title;
  final String description;
  bool completed;

  TaskModel({
    required this.title,
    required this.description,
    this.completed = false,
  });
}