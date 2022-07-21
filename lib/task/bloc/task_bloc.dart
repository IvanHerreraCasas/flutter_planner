import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tasks_repository/tasks_repository.dart';
part 'task_event.dart';
part 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc({
    required TasksRepository tasksRepository,
    required Task initialTask,
  })  : _tasksRepository = tasksRepository,
        super(
          TaskState(
            initialTask: initialTask,
            title: initialTask.title,
            isCompleted: initialTask.completed,
          ),
        ) {
    on<TaskTitleChanged>(_onTaskTitleChanged);
    on<TaskCompletetionToggled>(_onTaskCompletetionToggled);
    on<TaskSaved>(_onTaskSaved);
    on<TaskDeleted>(_onTaskDeleted);
  }

  final TasksRepository _tasksRepository;

  void _onTaskTitleChanged(
    TaskTitleChanged event,
    Emitter<TaskState> emit,
  ) {
    emit(state.copyWith(title: event.title));
  }

  void _onTaskCompletetionToggled(
    TaskCompletetionToggled event,
    Emitter<TaskState> emit,
  ) {
    emit(state.copyWith(isCompleted: !state.isCompleted));
    add(const TaskSaved());
  }

  Future<void> _onTaskSaved(
    TaskSaved event,
    Emitter<TaskState> emit,
  ) async {
    emit(state.copyWith(status: TaskStatus.loading));
    final task = state.initialTask.copyWith(
      title: state.title,
      completed: state.isCompleted,
    );
    try {
      final savedTask = await _tasksRepository.saveTask(task);
      emit(
        state.copyWith(
          status: TaskStatus.success,
          initialTask: savedTask,
        ),
      );
    } catch (e) {
      log('TaskBloc(55) --- error: ${e.toString()}');
      emit(state.copyWith(status: TaskStatus.failure));
    }
  }

  Future<void> _onTaskDeleted(
    TaskDeleted event,
    Emitter<TaskState> emit,
  ) async {
    if (state.initialTask.id != null) {
      try {
        emit(state.copyWith(status: TaskStatus.loading));

        await _tasksRepository.deleteTask(state.initialTask.id!);

        emit(state.copyWith(status: TaskStatus.success));
      } catch (e) {
        log('TaskBloc(78) --- error: ${e.toString}');
        emit(state.copyWith(status: TaskStatus.failure));
      }
    }
  }
}
