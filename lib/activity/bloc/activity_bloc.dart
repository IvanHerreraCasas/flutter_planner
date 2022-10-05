import 'dart:developer';

import 'package:activities_repository/activities_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_planner/helpers/helpers.dart';
import 'package:intl/intl.dart';
import 'package:reminders_repository/reminders_repository.dart';

part 'activity_event.dart';
part 'activity_state.dart';

class ActivityBloc extends Bloc<ActivityEvent, ActivityState> {
  ActivityBloc({
    required RemindersRepository remindersRepository,
    required ActivitiesRepository activitiesRepository,
    required Activity initialActivity,
  })  : _remindersRepository = remindersRepository,
        _activitiesRepository = activitiesRepository,
        super(
          ActivityState(
            initialActivity: initialActivity,
            name: initialActivity.name,
            type: initialActivity.type,
            description: initialActivity.description,
            date: initialActivity.date,
            startTime: initialActivity.startTime,
            endTime: initialActivity.endTime,
            isAllDay: initialActivity.isAllDay,
          ),
        ) {
    on<ActivityRemindersRequested>(_onRemindersRequested);
    on<ActivitySaved>(_onSaved);
    on<ActivityDeleted>(_onDeleted);
    on<ActivityNameChanged>(_onNameChanged);
    on<ActivityTypeChanged>(_onTypeChanged);
    on<ActivityAllDayToggled>(_onAllDayToggled);
    on<ActivityDescriptionChanged>(_onDescriptionChanged);
    on<ActivityDateChanged>(_onDateChanged);
    on<ActivityStartTimeChanged>(_onStartTimeChanged);
    on<ActivityEndTimeChanged>(_onEndTimeChanged);
    on<ActivityLinksChanged>(_onLinksChanged);
    on<ActivityReminderValuesChanged>(_onReminderValuesChanged);
  }

  final ActivitiesRepository _activitiesRepository;

  final RemindersRepository _remindersRepository;

  Future<void> _onRemindersRequested(
    ActivityRemindersRequested event,
    Emitter<ActivityState> emit,
  ) async {
    final activityID = state.initialActivity.id;
    List<bool> reminderValues;

    if (activityID != null) {
      /// each activity will have 20 notification slots
      /// the first 100 slots are left in case the app needs it for other cases
      ///
      /// for example:
      /// activityID = 0 => remindersIDs = [100,...,119]
      /// activityID = 1 => remindersIDs = [120,...,139]
      ///
      /// note: each reminder is a diferent notification.
      final reminderIDs = List.generate(
        20,
        (index) => (activityID + 5) * 20 + index,
      );

      reminderValues = await _remindersRepository.checkReminders(
        ids: reminderIDs,
      );
    } else {
      reminderValues = List.generate(20, (index) => false);
    }
    emit(state.copyWith(reminderValues: reminderValues));
  }

  Future<void> _onSaved(
    ActivitySaved event,
    Emitter<ActivityState> emit,
  ) async {
    emit(state.copyWith(status: ActivityStatus.loading));

    final startTime = state.isAllDay ? DateTime(1970) : state.startTime;
    final endTime = state.isAllDay ? DateTime(1970) : state.endTime;

    final activity = state.initialActivity.copyWith(
      name: state.name,
      type: state.type,
      description: state.description,
      date: state.date,
      startTime: startTime,
      endTime: endTime,
      links: state.links,
    );

    try {
      final savedActivity = await _activitiesRepository.saveActivity(activity);

      if (savedActivity.id != null) {
        await _saveReminders(savedActivity.id!);
      }

      emit(state.copyWith(status: ActivityStatus.success));
    } catch (e) {
      log('ActivityBloc(105) --- error: ${e.toString()}');
      emit(
        state.copyWith(
          status: ActivityStatus.failure,
          errorMessage: 'error: activity could not be saved',
        ),
      );
    }
  }

  Future<void> _saveReminders(int activityID) async {
    final reminderValues = state.reminderValues;
    final date = state.date;
    if (reminderValues.isEmpty) return;

    if (state.isAllDay) {
      for (var index = 0; index < 5; index++) {
        final reminderID = (activityID + 5) * 20 + index;
        if (reminderValues[index]) {
          late DateTime reminderDateTime;

          switch (index) {
            case 0:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                8,
              );
              break;
            case 1:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 1,
                8,
              );
              break;
            case 2:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 2,
                8,
              );
              break;
            case 3:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 3,
                8,
              );
              break;
            case 4:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 7,
                8,
              );
              break;
            default:
              return;
          }
          final reminder = Reminder(
            id: reminderID,
            title: state.name,
            dateTime: reminderDateTime,
            body: DateFormat.MMMMd().format(date),
          );
          await _remindersRepository.saveReminder(reminder: reminder);
        } else {
          await _remindersRepository.deleteReminder(id: reminderID);
        }
      }
    } else {
      final startTime = state.startTime;
      for (var index = 0; index < 9; index++) {
        final reminderID = (activityID + 5) * 20 + index;
        if (reminderValues[index]) {
          late DateTime reminderDateTime;

          switch (index) {
            case 0:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour,
                startTime.minute,
              );
              break;
            case 1:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour,
                startTime.minute - 5,
              );
              break;
            case 2:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour,
                startTime.minute - 15,
              );
              break;
            case 3:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour,
                startTime.minute - 30,
              );
              break;
            case 4:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour - 1,
                startTime.minute,
              );
              break;
            case 5:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day,
                startTime.hour - 4,
                startTime.minute,
              );
              break;
            case 6:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 1,
                startTime.hour,
                startTime.minute,
              );
              break;
            case 7:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 2,
                startTime.hour,
                startTime.minute,
              );
              break;
            case 8:
              reminderDateTime = DateTime(
                date.year,
                date.month,
                date.day - 7,
                startTime.hour,
                startTime.minute,
              );
              break;
            default:
              return;
          }

          final reminder = Reminder(
            id: reminderID,
            title: state.name,
            dateTime: reminderDateTime,
            body: DateFormat('MMMM d - HH:mm').format(
              date.copyWith(
                hour: startTime.hour,
                minute: startTime.minute,
              ),
            ),
          );
          await _remindersRepository.saveReminder(reminder: reminder);
        } else {
          await _remindersRepository.deleteReminder(id: reminderID);
        }
      }
    }
  }

  Future<void> _deleteAllReminders(int activityID) async {
    final reminderValues = state.reminderValues;
    if (reminderValues.isEmpty) return;

    for (var index = 0; index < 20; index++) {
      final reminderID = (activityID + 5) * 20 + index;

      await _remindersRepository.deleteReminder(id: reminderID);
    }
  }

  Future<void> _onDeleted(
    ActivityDeleted event,
    Emitter<ActivityState> emit,
  ) async {
    if (state.initialActivity.id != null) {
      emit(state.copyWith(status: ActivityStatus.loading));
      try {
        await _activitiesRepository.deleteActivity(state.initialActivity.id!);
        await _deleteAllReminders(state.initialActivity.id!);
        emit(state.copyWith(status: ActivityStatus.success));
      } catch (e) {
        log('ActivityBloc(311) --- error: ${e.toString()}');
        emit(
          state.copyWith(
            status: ActivityStatus.failure,
            errorMessage: 'error: activity could not be deleted',
          ),
        );
      }
    }
  }

  void _onNameChanged(
    ActivityNameChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  void _onTypeChanged(
    ActivityTypeChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(type: event.type));
  }

  void _onAllDayToggled(
    ActivityAllDayToggled event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(isAllDay: !state.isAllDay));
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
    emit(
      state.copyWith(
        date: DateTime.utc(
          event.date.year,
          event.date.month,
          event.date.day,
        ),
      ),
    );
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

  void _onReminderValuesChanged(
    ActivityReminderValuesChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(
      state.copyWith(reminderValues: event.reminderValues),
    );
  }

  void _onLinksChanged(
    ActivityLinksChanged event,
    Emitter<ActivityState> emit,
  ) {
    emit(state.copyWith(links: event.links));
  }
}
