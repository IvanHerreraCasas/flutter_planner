import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc() : super(const AppState()) {
    on<AppRouteChanged>(_onRouteChanged);
    on<AppThemeModeChanged>(_onThemeModeChanged);
    on<AppSettingsIndexChanged>(_onSettingsIndexChanged);
    on<AppTimelineStartHourChanged>(_onAppTimelineStartHourChanged);
    on<AppTimelineEndHourChanged>(_onAppTimelineEndHourChanged);
  }

  void _onRouteChanged(
    AppRouteChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(route: event.route));
  }

  void _onThemeModeChanged(
    AppThemeModeChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(themeModeIndex: event.index));
  }

  void _onSettingsIndexChanged(
    AppSettingsIndexChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(settingsIndex: event.index));
  }

  void _onAppTimelineStartHourChanged(
    AppTimelineStartHourChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(timelineStartHour: event.hour));
  }

  void _onAppTimelineEndHourChanged(
    AppTimelineEndHourChanged event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(timelineEndHour: event.hour));
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) => AppState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toJson();
}
