import 'dart:developer';

import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    required ActivitiesRepository activitiesRepository,
    required Activity initialActivity,
  })  : _activitiesRepository = activitiesRepository,
        super(
          ActivityState(
            initialActivity: initialActivity,
            name: initialActivity.name,
            description: initialActivity.description,
            date: initialActivity.date,
            startTime: initialActivity.startTime,
            endTime: initialActivity.endTime,
          ),
        ) {
    on<ActivitySaved>(_onSaved);
    on<ActivityDeleted>(_onDeleted);
    on<ActivityNameChanged>(_onNameChanged);
    on<ActivityDescriptionChanged>(_onDescriptionChanged);
    on<ActivityDateChanged>(_onDateChanged);
    on<ActivityStartTimeChanged>(_onStartTimeChanged);
    on<ActivityEndTimeChanged>(_onEndTimeChanged);
    on<ActivityLinksChanged>(_onLinksChanged);
  }

  final ActivitiesRepository _activitiesRepository;

  Future<void> _onSaved(
    ActivitySaved event,
    Emitter<ActivityState> emit,
  ) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    final activity = state.initialActivity.copyWith(
      name: state.name,
      description: state.description,
      date: state.date,
      startTime: state.startTime,
      endTime: state.endTime,
      links: state.links,
    );

    try {
      await _activitiesRepository.saveActivity(activity);
      emit(state.copyWith(status: ActivityStatus.success));
    } catch (e) {
      log('ActivityBloc(56) --- error: ${e.toString()}');
      emit(state.copyWith(status: ActivityStatus.failure));
    }
  }

  Future<void> _onDeleted(
    ActivityDeleted event,
    Emitter<ActivityState> emit,
  ) async {
    emit(state.copyWith(status: ActivityStatus.loading));
    if (state.initialActivity.id != null) {
      try {
        await _activitiesRepository.deleteActivity(state.initialActivity.id!);
        emit(state.copyWith(status: ActivityStatus.success));
      } catch (e) {
        log('ActivityBloc(71) --- error: ${e.toString()}');
        emit(state.copyWith(status: ActivityStatus.failure));
      }
    }
  }

  void _onNameChanged(
    ActivityNameChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onDescriptionChanged(
    ActivityDescriptionChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(description: event.description));
  }

  void _onDateChanged(
    ActivityDateChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(date: event.date));
  }

  void _onStartTimeChanged(
    ActivityStartTimeChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(startTime: event.startTime));
  }

  void _onEndTimeChanged(
    ActivityEndTimeChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(endTime: event.endTime));
  }

  void _onLinksChanged(
    ActivityLinksChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(links: event.links));
  }
}
