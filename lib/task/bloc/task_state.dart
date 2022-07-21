part of 'task_bloc.dart';

enum TaskStatus { initial, loading, success, failure }

class TaskState extends Equatable {
  const TaskState({
    this.status = TaskStatus.initial,
    required this.initialTask,
    this.title = '',
    this.isCompleted = false,
  });

  final TaskStatus status;
  final Task initialTask;
  final String title;
  final bool isCompleted;

  TaskState copyWith({
    TaskStatus? status,
    Task? initialTask,
    String? title,
    bool? isCompleted,
  }) {
    return TaskState(
      status: status ?? this.status,
      initialTask: initialTask ?? this.initialTask,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [
        status,
        initialTask,
        title,
        isCompleted,
      ];
}
