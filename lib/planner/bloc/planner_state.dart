part of 'planner_bloc.dart';

class PlannerState extends Equatable {
  PlannerState({
    DateTime? selectedDay,
    DateTime? focusedDay,
    this.activities = const [],
    this.tasks = const [],
    this.selectedTab = 0,
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

  final int selectedTab;

  PlannerState copyWith({
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<Activity>? activities,
    List<Task>? tasks,
    int? selectedTab,
  }) {
    return PlannerState(
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      activities: activities ?? this.activities,
      tasks: tasks ?? this.tasks,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [
        selectedDay,
        focusedDay,
        activities,
        tasks,
        selectedTab,
      ];
}
