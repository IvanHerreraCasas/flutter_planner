import 'dart:developer';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'planner_event.dart';
part 'planner_state.dart';

class PlannerBloc extends Bloc<PlannerEvent, PlannerState> {
  PlannerBloc({
    required ActivitiesRepository activitiesRepository,
    required RoutinesRepository routinesRepository,
    required TasksRepository tasksRepository,
    required String userID,
  })  : _activitiesRepository = activitiesRepository,
        _routinesRepository = routinesRepository,
        _tasksRepository = tasksRepository,
        _userID = userID,
        super(PlannerState()) {
    on<PlannerSubscriptionRequested>(
      _onSubscriptionRequested,
      transformer: restartable(),
    );
    on<PlannerEventsSubRequested>(
      _onEventsSubRequested,
      transformer: restartable(),
    );
    on<PlannerTasksSubRequested>(
      _onTasksSubRequested,
      transformer: restartable(),
    );
    on<PlannerSelectedDayChanged>(_onSelectedDayChanged);
    on<PlannerFocusedDayChanged>(_onFocusedDayChanged);
    on<PlannerAddRoutines>(_onAddRoutines);
    on<PlannerNewTaskAdded>(_onNewTaskAdded);
    on<PlannerSelectedTabChanged>(_onSelectedTabChanged);
  }

  final ActivitiesRepository _activitiesRepository;
  final RoutinesRepository _routinesRepository;
  final TasksRepository _tasksRepository;
  final String _userID;

  Future<void> _onSubscriptionRequested(
    PlannerSubscriptionRequested event,
    Emitter<PlannerState> emit,
  ) async {
    emit(state.copyWith(status: PlannerStatus.loading));
    await emit.forEach<List<Activity>>(
      _activitiesRepository.streamActivities(
        date: state.selectedDay,
      ),
      onData: (activities) => state.copyWith(
        status: PlannerStatus.success,
        activities: activities,
      ),
      onError: (error, stack) {
        log('PlannerBloc(62) --- error: ${error.toString()}');
        return state.copyWith(
          status: PlannerStatus.failure,
          errorMessage: 'error: activities could not be loaded',
        );
      },
    );
  }

  Future<void> _onEventsSubRequested(
    PlannerEventsSubRequested event,
    Emitter<PlannerState> emit,
  ) async {
    emit(state.copyWith(status: PlannerStatus.loading));

    await emit.forEach<List<Activity>>(
      _activitiesRepository.streamEvents(
        lower: DateTime.utc(
          state.focusedDay.year,
          state.focusedDay.month - 2,
        ),
        upper: DateTime.utc(
          state.focusedDay.year,
          state.focusedDay.month + 2,
        ),
      ),
      onData: (events) => state.copyWith(
        status: PlannerStatus.success,
        events: events,
      ),
      onError: (error, stack) {
        log('PlannerBloc(90) --- error: ${error.toString()}');
        return state.copyWith(
          status: PlannerStatus.failure,
          errorMessage: 'error: events could not be loaded',
        );
      },
    );
  }

  Future<void> _onTasksSubRequested(
    PlannerTasksSubRequested event,
    Emitter<PlannerState> emit,
  ) async {
    emit(state.copyWith(status: PlannerStatus.loading));
    await emit.forEach<List<Task>>(
      _tasksRepository.streamTasks(date: state.selectedDay),
      onData: (tasks) => state.copyWith(
        status: PlannerStatus.success,
        tasks: tasks,
      ),
      onError: (error, stack) {
        log('PlannerBloc(111) --- error: ${error.toString()}');
        return state.copyWith(
          status: PlannerStatus.failure,
          errorMessage: 'error: tasks could not be loaded',
        );
      },
    );
  }

  void _onSelectedDayChanged(
    PlannerSelectedDayChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(selectedDay: event.selectedDay));
    add(const PlannerSubscriptionRequested());
    add(const PlannerTasksSubRequested());
  }

  void _onFocusedDayChanged(
    PlannerFocusedDayChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(focusedDay: event.focusedDay));
    add(const PlannerEventsSubRequested());
  }

  Future<void> _onAddRoutines(
    PlannerAddRoutines event,
    Emitter<PlannerState> emit,
  ) async {
    emit(state.copyWith(status: PlannerStatus.loading));
    final day = state.selectedDay.weekday;
    try {
      final routines = (await _routinesRepository.fetchRoutines())
          .where((routine) => routine.day == day)
          .toList();

      final pendentRoutines = <Routine>[];

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
              type: 2,
              date: state.selectedDay,
              startTime: routine.startTime,
              endTime: routine.endTime,
              routineID: routine.id,
            ),
          )
          .toList();

      await _activitiesRepository.insertActivities(newActivities);
      emit(state.copyWith(status: PlannerStatus.success));
    } catch (e) {
      log('PlannerBloc(136) --- error: ${e.toString()}');
      emit(
        state.copyWith(
          status: PlannerStatus.failure,
          errorMessage: 'error: routines could not be added',
        ),
      );
    }
  }

  Future<void> _onNewTaskAdded(
    PlannerNewTaskAdded event,
    Emitter<PlannerState> emit,
  ) async {
    emit(state.copyWith(status: PlannerStatus.loading));
    try {
      final newTask = Task(
        userID: _userID,
        date: state.selectedDay,
        completed: false,
      );

      await _tasksRepository.saveTask(newTask);
      emit(state.copyWith(status: PlannerStatus.success));
    } catch (e) {
      log('PlannerBloc(159) --- error: ${e.toString()}');
      emit(
        state.copyWith(
          status: PlannerStatus.failure,
          errorMessage: 'error: task could not be added',
        ),
      );
    }
  }

  void _onSelectedTabChanged(
    PlannerSelectedTabChanged event,
    Emitter<PlannerState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.selectedTab));
  }

  @override
  Future<void> close() async {
    await _activitiesRepository.dispose();
    return super.close();
  }
}
