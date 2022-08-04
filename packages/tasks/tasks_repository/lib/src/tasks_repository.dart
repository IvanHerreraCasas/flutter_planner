import 'package:tasks_api/tasks_api.dart';

/// {@template tasks_repository}
/// A repository that handles task related requests.
/// {@endtemplate}
class TasksRepository {
  /// {@macro tasks_repository}
  TasksRepository({
    required TasksApi tasksApi,
  }) : _tasksApi = tasksApi;

  final TasksApi _tasksApi;

  /// Provides a [Stream] of tasks from a [date]
  Stream<List<Task>> streamTasks({required DateTime date}) =>
      _tasksApi.streamTasks(date: date).asBroadcastStream();

  /// Saves a [task]
  ///
  /// If a [task] with the same id already exists, it will be replaced.
  Future<Task> saveTask(Task task) => _tasksApi.saveTask(task);

  /// Deletes the task with the given [id].
  Future<void> deleteTask(int id) => _tasksApi.deleteTask(id);
}
