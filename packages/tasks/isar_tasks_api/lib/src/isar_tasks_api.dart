import 'package:isar/isar.dart';
import 'package:isar_tasks_api/src/models/isar_task.dart';
import 'package:tasks_api/tasks_api.dart';

/// {@template isar_tasks_api}
/// A Very Good Project created by Very Good CLI.
/// {@endtemplate}
class IsarTasksApi extends TasksApi {
  /// {@macro isar_tasks_api}
  IsarTasksApi({
    required Isar isar,
  })  : _isar = isar,
        _tasksCollection = isar.isarTasks;

  final Isar _isar;
  final IsarCollection<IsarTask> _tasksCollection;

  @override
  Stream<List<Task>> streamTasks({required DateTime date}) async* {
    final isarTasksStream = _tasksCollection
        .filter()
        .dateEqualTo(date)
        .build()
        .watch(initialReturn: true);

    yield* isarTasksStream.map(
      (isarRoutines) => isarRoutines.map((e) => e.toTask()).toList(),
    );
  }

  @override
  Future<Task> saveTask(Task task) async {
    return _isar.writeTxn<Task>(() async {
      final id = await _tasksCollection.put(task.toIsarModel());

      return task.copyWith(id: id);
    });
  }

  @override
  Future<void> deleteTask(int id) {
    return _isar.writeTxn(() => _tasksCollection.delete(id));
  }
}
