part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.route = '/sign-in',
    this.themeModeIndex = 0,
    this.settingsIndex = 0,
    this.timelineStartHour = 7,
    this.timelineEndHour = 22,
    this.tasksReminderTimes = const [],
    this.tasksReminderValues = const [],
  });

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    final _tasksReminderTimesJson =
        (jsonMap['tasks_reminder_times'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>();

    final tasksReminderTimes =
        _tasksReminderTimesJson?.map(DateTimeJson.fromJson).toList() ?? [];

    return AppState(
      route: jsonMap['route'] as String? ?? '',
      themeModeIndex: jsonMap['theme_mode_index'] as int? ?? 0,
      timelineStartHour: jsonMap['timeline_start_hour'] as int? ?? 7,
      timelineEndHour: jsonMap['timeline_end_hour'] as int? ?? 22,
      tasksReminderTimes: tasksReminderTimes,
      tasksReminderValues:
          (jsonMap['tasks_reminder_values'] as List<dynamic>?)?.cast<bool>() ??
              const [],
    );
  }

  final String route;
  final int themeModeIndex;
  final int settingsIndex;
  final int timelineStartHour;
  final int timelineEndHour;
  final List<DateTime> tasksReminderTimes;
  final List<bool> tasksReminderValues;

  bool get tasksRemindersAreAllowed =>
      tasksReminderTimes.length == 3 && tasksReminderValues.length == 3;

  Map<String, dynamic> toJson() {
    final tasksReminderTimesJson = tasksReminderTimes
        .map(
          (dateTime) => dateTime.toJson(),
        )
        .toList();

    return <String, dynamic>{
      'route': route,
      'theme_mode_index': themeModeIndex,
      'timeline_start_hour': timelineStartHour,
      'timeline_end_hour': timelineEndHour,
      'tasks_reminder_times': tasksReminderTimesJson,
      'tasks_reminder_values': tasksReminderValues,
    };
  }

  AppState copyWith({
    String? route,
    int? themeModeIndex,
    int? settingsIndex,
    int? timelineStartHour,
    int? timelineEndHour,
    List<DateTime>? tasksReminderTimes,
    List<bool>? tasksReminderValues,
  }) {
    return AppState(
      route: route ?? this.route,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      settingsIndex: settingsIndex ?? this.settingsIndex,
      timelineStartHour: timelineStartHour ?? this.timelineStartHour,
      timelineEndHour: timelineEndHour ?? this.timelineEndHour,
      tasksReminderTimes: tasksReminderTimes ?? this.tasksReminderTimes,
      tasksReminderValues: tasksReminderValues ?? this.tasksReminderValues,
    );
  }

  @override
  List<Object?> get props => [
        route,
        themeModeIndex,
        settingsIndex,
        timelineStartHour,
        timelineEndHour,
        tasksReminderTimes,
        tasksReminderValues,
      ];
}
