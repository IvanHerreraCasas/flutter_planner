import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:routines_api/routines_api.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:table_calendar/table_calendar.dart';

part 'planner_event.dart';
part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc({
    required ActivitiesRepository activitiesRepository,
    required RoutinesRepository routinesRepository,
  })  : _activitiesRepository = activitiesRepository,
        _routinesRepository = routinesRepository,
        super(PlannerState()) {
    on<PlannerSubscriptionRequested>(_onSubscriptionRequested);
    on<PlannerActivitiesUpdated>(_onActivitiesUpdated);
    on<PlannerSelectedDayChanged>(_onSelectedDayChanged);
    on<PlannerFocusedDayChanged>(_onFocusedDayChanged);
    on<PlannerCalendarFormatChanged>(_onCalendarFormatChanged);
    on<PlannerSizeChanged>(_onLayoutSizeChanged);
    on<PlannerAddRoutines>(_onAddRoutines);
  }

  final ActivitiesRepository _activitiesRepository;
  final RoutinesRepository _routinesRepository;

  Future<void> _onSubscriptionRequested(
    PlannerSubscriptionRequested event,
    Emitter<PlannerState> emit,
  ) async {
    await emit.forEach<List<Activity>>(
      _activitiesRepository.streamActivities(
        date: state.selectedDay,
      ),
      onData: (activities) => state.copyWith(activities: activities),
      onError: (error, stack) {
        addError(error);
        return state;
      },
    );
  }

  Future<void> _onActivitiesUpdated(
    PlannerActivitiesUpdated event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      final activities = await _activitiesRepository.fetchActivities(
        date: state.selectedDay,
      );

      emit(state.copyWith(activities: activities));
    } catch (e) {
      addError(e);
    }
  }

  void _onSelectedDayChanged(
    PlannerSelectedDayChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(selectedDay: event.selectedDay));
    add(const PlannerActivitiesUpdated());
  }

  void _onFocusedDayChanged(
    PlannerFocusedDayChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(focusedDay: event.focusedDay));
  }

  void _onCalendarFormatChanged(
    PlannerCalendarFormatChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(calendarFormat: event.format));
  }

  void _onLayoutSizeChanged(
    PlannerSizeChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(size: event.plannerSize));
  }

  Future<void> _onAddRoutines(
    PlannerAddRoutines event,
    Emitter<PlannerState> emit,
  ) async {
    final day = state.selectedDay.weekday;
    try {
      final routines = (await _routinesRepository.fetchRoutines())
          .where((routine) => routine.day == day)
          .toList();

      final pendentRoutines = <Routine>[];

      for (final activity in state.activities) {
        if (activity.type == 2) {}
      }

      for (final routine in routines) {
        if (state.activities
                .indexWhere((activity) => activity.routineID == routine.id) ==
            -1) {
          pendentRoutines.add(routine);
        }
      }

      final newActivities = pendentRoutines
          .map(
            (routine) => Activity(
              userID: routine.userID,
              name: routine.name,
              date: state.selectedDay,
              startTime: routine.startTime,
              endTime: routine.endTime,
            ),
          )
          .toList();

      try {
        await _activitiesRepository.insertActivities(newActivities);
        add(const PlannerActivitiesUpdated());
      } catch (e) {
        addError(e);
      }
    } catch (e) {
      addError(e);
    }
  }

  @override
  Future<void> close() async {
    await _activitiesRepository.dispose();
    return super.close();
  }
}
