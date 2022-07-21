part of 'task_bloc.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => [];
}

class TaskSaved extends TaskEvent {
  const TaskSaved();
}

class TaskDeleted extends TaskEvent {
  const TaskDeleted();
}

class TaskTitleChanged extends TaskEvent {
  const TaskTitleChanged(this.title);

  final String title;

  @override
  List<Object?> get props => [title];
}

class TaskCompletetionToggled extends TaskEvent {
  const TaskCompletetionToggled();
}
