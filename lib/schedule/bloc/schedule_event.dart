part of 'schedule_bloc.dart';

abstract class ScheduleEvent extends Equatable {
  const ScheduleEvent();

  @override
  List<Object?> get props => [];
}

class ScheduleSubscriptionRequested extends ScheduleEvent {
  const ScheduleSubscriptionRequested();
}

class ScheduleRoutineChanged extends ScheduleEvent {
  const ScheduleRoutineChanged(this.routine);

  final Routine routine;

  @override
  List<Object?> get props => [routine];
}

class ScheduleSelectedRoutineChanged extends ScheduleEvent {
  const ScheduleSelectedRoutineChanged(this.selectedRoutine);

  final Routine? selectedRoutine;

  @override
  List<Object?> get props => [selectedRoutine];
}
