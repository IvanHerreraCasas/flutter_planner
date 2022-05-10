part of 'planner_bloc.dart';

abstract class PlannerEvent extends Equatable {
  const PlannerEvent();

  @override
  List<Object?> get props => [];
}

class PlannerSubscriptionRequested extends PlannerEvent {
  const PlannerSubscriptionRequested();
}

/// Used instead of subcription requested.
///
/// Issue with the stream: https://github.com/supabase-community/supabase-flutter/issues/99
class PlannerActivitiesUpdated extends PlannerEvent {
  const PlannerActivitiesUpdated();
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
