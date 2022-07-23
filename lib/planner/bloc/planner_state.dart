part of 'planner_bloc.dart';

enum PlannerStatus { initial, loading, success, failure }

class PlannerState extends Equatable {
  PlannerState({
    this.status = PlannerStatus.initial,
    DateTime? selectedDay,
    DateTime? focusedDay,
    this.activities = const [],
    this.tasks = const [],
    this.selectedTab = 0,
    this.errorMessage = '',
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

  final PlannerStatus status;

  late final DateTime selectedDay;
  late final DateTime focusedDay;

  final List<Activity> activities;
  final List<Task> tasks;

  final int selectedTab;

  final String errorMessage;

  PlannerState copyWith({
    PlannerStatus? status,
    DateTime? selectedDay,
    DateTime? focusedDay,
    List<Activity>? activities,
    List<Task>? tasks,
    int? selectedTab,
    String? errorMessage,
  }) {
    return PlannerState(
      status: status ?? this.status,
      selectedDay: selectedDay ?? this.selectedDay,
      focusedDay: focusedDay ?? this.focusedDay,
      activities: activities ?? this.activities,
      tasks: tasks ?? this.tasks,
      selectedTab: selectedTab ?? this.selectedTab,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        selectedDay,
        focusedDay,
        activities,
        tasks,
        selectedTab,
        errorMessage,
      ];
}
