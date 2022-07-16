part of 'planner_bloc.dart';

class PlannerState extends Equatable {
  PlannerState({
    DateTime? selectedDay,
    DateTime? focusedDay,
    this.activities = const [],
    this.tasks = const [],
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
  final List<Task> tasks;

  PlannerState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<Activity>? activities,
    List<Task>? tasks,
  }) {
    return PlannerState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      activities: activities ?? this.activities,
      tasks: tasks ?? this.tasks,
    );
  }

  @override
  List<Object?> get props => [
        selectedDay,
        focusedDay,
        activities,
        tasks,
      ];
}
