part of 'routine_bloc.dart';

abstract class RoutineEvent extends Equatable {
  const RoutineEvent();

  @override
  List<Object?> get props => [];
}

class RoutineNameChanged extends RoutineEvent {
  const RoutineNameChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

class RoutineDayChanged extends RoutineEvent {
  const RoutineDayChanged(this.day);

  final int day;

  @override
  List<Object?> get props => [day];
}

class RoutineStartTimeChanged extends RoutineEvent {
  const RoutineStartTimeChanged(this.startTime);

  final DateTime startTime;

  @override
  List<Object?> get props => [startTime];
}

class RoutineEndTimeChanged extends RoutineEvent {
  const RoutineEndTimeChanged(this.endTime);

  final DateTime endTime;

  @override
  List<Object?> get props => [endTime];
}

class RoutineSaved extends RoutineEvent {
  const RoutineSaved();
}

class RoutineDeleted extends RoutineEvent {
  const RoutineDeleted();
}
