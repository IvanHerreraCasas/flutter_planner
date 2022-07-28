part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.route = '/sign-in',
    this.themeModeIndex = 0,
    this.settingsIndex = 0,
    this.timelineStartHour = 7,
    this.timelineEndHour = 22,
  });

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    return AppState(
      route: jsonMap['route'] as String? ?? '',
      themeModeIndex: jsonMap['theme_mode_index'] as int? ?? 0,
      timelineStartHour: jsonMap['timeline_start_hour'] as int? ?? 7,
      timelineEndHour: jsonMap['timeline_end_hour'] as int? ?? 22,
    );
  }

  final String route;
  final int themeModeIndex;
  final int settingsIndex;
  final int timelineStartHour;
  final int timelineEndHour;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'route': route,
      'theme_mode_index': themeModeIndex,
      'timeline_start_hour': timelineStartHour,
      'timeline_end_hour': timelineEndHour,
    };
  }

  AppState copyWith({
    String? route,
    int? themeModeIndex,
    int? settingsIndex,
    int? timelineStartHour,
    int? timelineEndHour,
  }) {
    return AppState(
      route: route ?? this.route,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      settingsIndex: settingsIndex ?? this.settingsIndex,
      timelineStartHour: timelineStartHour ?? this.timelineStartHour,
      timelineEndHour: timelineEndHour ?? this.timelineEndHour,
    );
  }

  @override
  List<Object?> get props => [
        route,
        themeModeIndex,
        settingsIndex,
        timelineStartHour,
        timelineEndHour,
      ];
}
