part of 'planner_bloc.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

class PlannerSubscriptionRequested extends PlannerEvent {
  const PlannerSubscriptionRequested();
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

class PlannerCalendarFormatChanged extends PlannerEvent {
  const PlannerCalendarFormatChanged(this.format);

  final CalendarFormat format;

  @override
  List<Object?> get props => [format];
}

class PlannerSizeChanged extends PlannerEvent {
  const PlannerSizeChanged(this.plannerSize);

  final PlannerSize plannerSize;

  @override
  List<Object?> get props => [plannerSize];
}

class PlannerAddRoutines extends PlannerEvent {
  const PlannerAddRoutines();
}
