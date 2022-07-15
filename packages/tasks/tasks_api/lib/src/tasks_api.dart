import 'package:tasks_api/tasks_api.dart';

/// {@template tasks_api}
/// The interface for an API that provides access to a list of tasks.
/// {@endtemplate}
abstract class TasksApi {
  /// {@macro tasks_api}
  const TasksApi();

  /// Provides a [Stream] of tasks from a [date]
  Stream<List<Task>> streamTasks({required DateTime date});

  /// Saves a [task]
  /// 
  /// If a [task] with the same id already exists, it will be replaced.
  Future<Task> saveTask(Task task);

  /// Deletes the task with the given [id].
  Future<void> deleteTask(int id);
}
