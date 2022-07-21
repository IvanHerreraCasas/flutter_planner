import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_tasks_api/src/tasks_controller.dart';
import 'package:tasks_api/tasks_api.dart';

/// {@template supabase_tasks_api}
/// A Flutter implementation of the [TasksApi] that uses supabase.
/// {@endtemplate}
class SupabaseTasksApi extends TasksApi {
  /// {@macro supabase_tasks_api}
  SupabaseTasksApi({
    required SupabaseClient supabaseClient,
  }) : _supabaseClient = supabaseClient;

  final SupabaseClient _supabaseClient;

  final _tasksController = TasksController();

  Future<void> _updateData({required DateTime date}) async {
    final res = await _supabaseClient
        .from('tasks')
        .select()
        .eq('date', DateFormat('MM/dd/yyyy').format(date))
        .execute();

    if (res.hasError) throw Exception(res.error);

    final tasks = (res.data as List)
        .cast<Map<String, dynamic>>()
        .map(Task.fromJson)
        .toList();

    _tasksController.update(tasks);
  }

  @override
  Stream<List<Task>> streamTasks({required DateTime date}) async* {
    await _updateData(date: date);
    yield* _tasksController.stream;
  }

  @override
  Future<Task> saveTask(Task task) async {
    late Task _task;

    if (task.id == null) {
      final res = await _supabaseClient.from('tasks').insert(
        [task.toJson()..remove('id')],
      ).execute();

      if (res.hasError) throw Exception(res.error);

      _task = Task.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );

      _tasksController.addTask(_task);
    } else {
      final res = await _supabaseClient
          .from('tasks')
          .update(task.toJson())
          .eq('id', task.id)
          .execute();

      if (res.hasError) throw Exception(res.error);

      _task = Task.fromJson(
        (res.data as List).cast<Map<String, dynamic>>().first,
      );

      _tasksController.updateTask(_task);
    }
    return _task;
  }

  @override
  Future<void> deleteTask(int id) async {
    final res =
        await _supabaseClient.from('tasks').delete().eq('id', id).execute();

    if (res.hasError) throw Exception(res.error);

    _tasksController.deleteTask(id);
  }
}
