import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:routines_api/routines_api.dart';
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
    on<PlannerTasksSubRequested>(
      _onTasksSubRequested,
      transformer: restartable(),
    );
    on<PlannerSelectedDayChanged>(_onSelectedDayChanged);
    on<PlannerFocusedDayChanged>(_onFocusedDayChanged);
    on<PlannerAddRoutines>(_onAddRoutines);
    on<PlannerNewTaskAdded>(_onNewTaskAdded);
  }

  final ActivitiesRepository _activitiesRepository;
  final RoutinesRepository _routinesRepository;
  final TasksRepository _tasksRepository;
  final String _userID;

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

  Future<void> _onTasksSubRequested(
    PlannerTasksSubRequested event,
    Emitter<PlannerState> emit,
  ) async {
    await emit.forEach<List<Task>>(
      _tasksRepository.streamTasks(date: state.selectedDay),
      onData: (tasks) => state.copyWith(tasks: tasks),
      onError: (error, stack) {
        addError(error);
        return state;
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
      } catch (e) {
        addError(e);
      }
    } catch (e) {
      addError(e);
    }
  }

  Future<void> _onNewTaskAdded(
    PlannerNewTaskAdded event,
    Emitter<PlannerState> emit,
  ) async {
    try {
      final newTask = Task.empty(userID: _userID);
      await _tasksRepository.saveTask(newTask);
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
