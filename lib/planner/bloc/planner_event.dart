part of 'planner_bloc.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

class PlannerSubscriptionRequested extends PlannerEvent {
  const PlannerSubscriptionRequested();
}

class PlannerTasksSubRequested extends PlannerEvent {
  const PlannerTasksSubRequested();
}

class PlannerSelectedDayChanged extends PlannerEvent {
  const PlannerSelectedDayChanged(this.selectedDay);

  final DateTime selectedDay;

  @override
  List<Object?> get props => [selectedDay];
}

class PlannerFocusedDayChanged extends PlannerEvent {
  const PlannerFocusedDayChanged(this.focusedDay);

  final DateTime focusedDay;

  @override
  List<Object?> get props => [focusedDay];
}

class PlannerAddRoutines extends PlannerEvent {
  const PlannerAddRoutines();
}

class PlannerNewTaskAdded extends PlannerEvent {
  const PlannerNewTaskAdded();
}
