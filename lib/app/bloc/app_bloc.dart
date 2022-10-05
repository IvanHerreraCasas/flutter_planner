import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_planner/helpers/helpers.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends HydratedBloc<AppEvent, AppState> {
  AppBloc({
    required TasksRepository tasksRepository,
    required RemindersRepository remindersRepository,
  })  : _tasksRepository = tasksRepository,
        _remindersRepository = remindersRepository,
        super(const AppState()) {
    on<AppRouteChanged>(_onRouteChanged);
    on<AppThemeModeChanged>(_onThemeModeChanged);
    on<AppSettingsIndexChanged>(_onSettingsIndexChanged);
    on<AppTimelineStartHourChanged>(_onAppTimelineStartHourChanged);
    on<AppTimelineEndHourChanged>(_onAppTimelineEndHourChanged);
    on<AppTasksRemindersAllowed>(_onAppTasksRemindersAllowed);
    on<AppTasksRemindersDisabled>(_onAppTasksRemindersDisabled);
    on<AppTaskReminderValueChanged>(_onAppTaskReminderValueChanged);
    on<AppTaskReminderTimeChanged>(_onAppTaskReminderTimeChanged);

    _startTasksSubs();
  }

  final TasksRepository _tasksRepository;
  final RemindersRepository _remindersRepository;

  late StreamSubscription<List<Task>> _todayTasksSub;
  late StreamSubscription<List<Task>> _tomorrowTasksSub;

  final _incompletedTasksCounts = [0, 0];

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

  Future<void> _onAppTasksRemindersAllowed(
    AppTasksRemindersAllowed event,
    Emitter<AppState> emit,
  ) async {
    final tasksReminderTimes = [
      DateTime(1970, 1, 1, 8),
      DateTime(1970, 1, 1, 12),
      DateTime(1970, 1, 1, 20),
    ];

    final tasksReminderValues = [false, false, false];

    emit(
      state.copyWith(
        tasksReminderTimes: tasksReminderTimes,
        tasksReminderValues: tasksReminderValues,
      ),
    );
  }

  Future<void> _onAppTasksRemindersDisabled(
    AppTasksRemindersDisabled event,
    Emitter<AppState> emit,
  ) async {
    emit(
      state.copyWith(
        tasksReminderTimes: const [],
        tasksReminderValues: const [],
      ),
    );

    try {
      await _deleteTasksReminders();
    } catch (e) {
      log('AppBloc(105) --- error: ${e.toString()}');
    }
  }

  Future<void> _onAppTaskReminderValueChanged(
    AppTaskReminderValueChanged event,
    Emitter<AppState> emit,
  ) async {
    final tasksReminderValues = List.of(state.tasksReminderValues);

    tasksReminderValues[event.index] = event.value;

    emit(
      state.copyWith(
        tasksReminderValues: tasksReminderValues,
      ),
    );

    try {
      await _saveTasksReminders();
    } catch (e) {
      log('AppBloc(126) --- error: ${e.toString()}');
    }
  }

  Future<void> _onAppTaskReminderTimeChanged(
    AppTaskReminderTimeChanged event,
    Emitter<AppState> emit,
  ) async {
    final tasksReminderTimes = List.of(state.tasksReminderTimes);

    tasksReminderTimes[event.index] = event.time;

    emit(
      state.copyWith(
        tasksReminderTimes: tasksReminderTimes,
      ),
    );

    try {
      await _saveTasksReminders();
    } catch (e) {
      log('AppBloc(147) --- error: ${e.toString()}');
    }
  }

  Future<void> _startTasksSubs() async {
    final currentDateTime = DateTime.now();
    final utcTodayDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );

    final utcTomorrowDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day + 1,
    );

    _todayTasksSub = _tasksRepository.streamTasks(date: utcTodayDate).listen(
      (tasks) {
        final incompletedTasks = List.of(tasks)
          ..retainWhere(
            (task) => !task.completed,
          );

        _incompletedTasksCounts[0] = incompletedTasks.length;

        if (state.tasksRemindersAreAllowed) {
          _saveTasksReminders();
        }
      },
    );

    _tomorrowTasksSub =
        _tasksRepository.streamTasks(date: utcTomorrowDate).listen(
      (tasks) {
        final incompletedTasks = List.of(tasks)
          ..retainWhere(
            (task) => !task.completed,
          );

        _incompletedTasksCounts[1] = incompletedTasks.length;

        if (state.tasksRemindersAreAllowed) {
          _saveTasksReminders();
        }
      },
    );
  }

  Future<void> _saveTasksReminders() async {
    final currentDateTime = DateTime.now();

    for (var index = 0; index < 3; index++) {
      for (var dayDiff = 0; dayDiff < 2; dayDiff++) {
        final incompletedTasksCount = _incompletedTasksCounts[dayDiff];
        final id = dayDiff * 10 + index;

        if (state.tasksReminderValues[index] && incompletedTasksCount > 0) {
          final taskReminderTime = state.tasksReminderTimes[index];
          final reminderDateTime = DateTime(
            currentDateTime.year,
            currentDateTime.month,
            currentDateTime.day + dayDiff,
            taskReminderTime.hour,
            taskReminderTime.minute,
          );

          final reminder = Reminder(
            id: id,
            title: 'Remainig tasks: $incompletedTasksCount',
            dateTime: reminderDateTime,
          );
          await _remindersRepository.saveReminder(reminder: reminder);
        } else {
          await _remindersRepository.deleteReminder(id: id);
        }
      }
    }
  }

  Future<void> _deleteTasksReminders() async {
    for (var index = 0; index < 3; index++) {
      for (var dayDiff = 0; dayDiff < 2; dayDiff++) {
        await _remindersRepository.deleteReminder(id: dayDiff * 10 + index);
      }
    }
  }

  @override
  AppState? fromJson(Map<String, dynamic> json) => AppState.fromJson(json);

  @override
  Map<String, dynamic>? toJson(AppState state) => state.toJson();

  @override
  Future<void> close() {
    _todayTasksSub.cancel();
    _tomorrowTasksSub.cancel();
    return super.close();
  }
}
