part of 'app_bloc.dart';

class AppState extends Equatable {
  const AppState({
    this.route = '/sign-in',
    this.themeModeIndex = 0,
    this.settingsIndex = 0,
  });

  factory AppState.fromJson(Map<String, dynamic> jsonMap) {
    return AppState(
      route: jsonMap['route'] as String? ?? '',
      themeModeIndex: jsonMap['theme_mode_index'] as int? ?? 0,
    );
  }

  final String route;
  final int themeModeIndex;
  final int settingsIndex;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'route': route,
      'theme_mode_index': themeModeIndex,
    };
  }

  AppState copyWith({
    String? route,
    int? themeModeIndex,
    int? settingsIndex,
  }) {
    return AppState(
      route: route ?? this.route,
      themeModeIndex: themeModeIndex ?? this.themeModeIndex,
      settingsIndex: settingsIndex ?? this.settingsIndex,
    );
  }

  @override
  List<Object?> get props => [
        route,
        themeModeIndex,
        settingsIndex,
      ];
}
