part of 'planner_bloc.dart';

class PlannerState extends Equatable {
  PlannerState({
    DateTime? selectedDay,
    DateTime? focusedDay,
    this.activities = const [],
    this.calendarFormat = CalendarFormat.month,
    this.size = PlannerSize.large,
  }) {
    final currentDateTime = DateTime.now();
    final utcTodayDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );
    this.selectedDay = selectedDay ?? utcTodayDate;
    this.focusedDay = focusedDay ?? utcTodayDate;
  }

  late final DateTime selectedDay;
  late final DateTime focusedDay;

  final List<Activity> activities;

  final CalendarFormat calendarFormat;

  final PlannerSize size;

  PlannerState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<Activity>? activities,
    CalendarFormat? calendarFormat,
    PlannerSize? size,
  }) {
    return PlannerState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      activities: activities ?? this.activities,
      calendarFormat: calendarFormat ?? this.calendarFormat,
      size: size ?? this.size,
    );
  }

  @override
  List<Object?> get props => [
        selectedDay,
        focusedDay,
        activities,
        calendarFormat,
        size,
      ];
}
