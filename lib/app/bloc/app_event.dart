part of 'app_bloc.dart';

abstract class AppEvent extends Equatable {
  const AppEvent();

  @override
  List<Object?> get props => [];
}

class AppRouteChanged extends AppEvent {
  const AppRouteChanged(this.route);

  final String route;

  @override
  List<Object?> get props => [route];
}

class AppThemeModeChanged extends AppEvent {
  const AppThemeModeChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AppSettingsIndexChanged extends AppEvent {
  const AppSettingsIndexChanged(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class AppTimelineStartHourChanged extends AppEvent {
  const AppTimelineStartHourChanged(this.hour);

  final int hour;

  @override
  List<Object?> get props => [hour];
}

class AppTimelineEndHourChanged extends AppEvent {
  const AppTimelineEndHourChanged(this.hour);

  final int hour;

  @override
  List<Object?> get props => [hour];
}

class AppTasksRemindersAllowed extends AppEvent {
  const AppTasksRemindersAllowed();
}

class AppTasksRemindersDisabled extends AppEvent {
  const AppTasksRemindersDisabled();
}

class AppTaskReminderValueChanged extends AppEvent {
  const AppTaskReminderValueChanged({required this.index, required this.value});

  final int index;
  final bool value;

  @override
  List<Object?> get props => [index, value];
}

class AppTaskReminderTimeChanged extends AppEvent {
  const AppTaskReminderTimeChanged({required this.index, required this.time});

  final int index;
  final DateTime time;

  @override
  List<Object?> get props => [index, time];
}
