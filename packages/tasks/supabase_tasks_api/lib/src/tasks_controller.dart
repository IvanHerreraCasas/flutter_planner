// ignore_for_file: public_member_api_docs

import 'package:rxdart/rxdart.dart';
import 'package:tasks_api/tasks_api.dart';

class TasksController {
  TasksController();

  final _streamController = BehaviorSubject<List<Task>>();

  Stream<List<Task>> get stream => _streamController.stream;

  void update(List<Task> tasks) {
    _streamController.add(tasks);
  }

  void addTask(Task task) {
    final tasks = [..._streamController.value, task];

    _streamController.add(tasks);
  }

  void updateTask(Task newTask) {
    final tasks = List.of(_streamController.value);

    final taskIndex = tasks.indexWhere((task) => task.id == newTask.id);

    tasks.replaceRange(taskIndex, taskIndex + 1, [newTask]);

    _streamController.add(tasks);
  }

  void deleteTask(int id) {
    final tasks = List.of(_streamController.value)
      ..removeWhere((task) => task.id == id);

    _streamController.add(tasks);
  }
}
