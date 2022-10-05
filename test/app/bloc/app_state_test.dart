// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    AppState createSubject({
      String route = '/sign-in',
      int themeModeIndex = 0,
      int settingIndex = 0,
      int timelineStartHour = 7,
      int timelineEndHour = 22,
      List<DateTime> tasksReminderTimes = const [],
      List<bool> tasksReminderValues = const [],
    }) {
      return AppState(
        route: route,
        themeModeIndex: themeModeIndex,
        settingsIndex: settingIndex,
        timelineStartHour: timelineStartHour,
        timelineEndHour: timelineEndHour,
        tasksReminderTimes: tasksReminderTimes,
        tasksReminderValues: tasksReminderValues,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          '/sign-in',
          0,
          0,
          7,
          22,
          <DateTime>[],
          <bool>[],
        ]),
      );
    });

    group('tasksRemindersAreAllowed', () {
      test('returns true if reminder values and times length are both 3', () {
        final appState = createSubject(
          tasksReminderTimes: [DateTime(1970), DateTime(1970), DateTime(1970)],
          tasksReminderValues: [true, true, true],
        );
        expect(appState.tasksRemindersAreAllowed, true);
      });
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            route: null,
            themeModeIndex: null,
            settingsIndex: null,
            timelineStartHour: null,
            timelineEndHour: null,
            tasksReminderTimes: null,
            tasksReminderValues: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            route: '/home',
            themeModeIndex: 1,
            settingsIndex: 1,
            timelineStartHour: 8,
            timelineEndHour: 24,
            tasksReminderTimes: [DateTime(2022, 10, 1)],
            tasksReminderValues: [true],
          ),
          equals(
            createSubject(
              route: '/home',
              themeModeIndex: 1,
              settingIndex: 1,
              timelineStartHour: 8,
              timelineEndHour: 24,
              tasksReminderTimes: [DateTime(2022, 10, 1)],
              tasksReminderValues: [true],
            ),
          ),
        );
      });
    });

    test('fromJson works properly', () {
      expect(
        AppState.fromJson(const <String, dynamic>{
          'route': '/home',
          'theme_mode_index': 1,
          'timeline_start_hour': 8,
          'timeline_end_hour': 24,
          'tasks_reminder_times': <Map<String, dynamic>>[
            <String, dynamic>{
              'year': 1970,
              'month': 1,
              'day': 1,
              'hour': 8,
              'minute': 0,
              'second': 0,
              'millisecond': 0,
              'microsecond': 0,
            },
          ],
          'tasks_reminder_values': <bool>[true],
        }),
        equals(
          createSubject(
            route: '/home',
            themeModeIndex: 1,
            timelineStartHour: 8,
            timelineEndHour: 24,
            tasksReminderTimes: [DateTime(1970, 1, 1, 8)],
            tasksReminderValues: [true],
          ),
        ),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject(
          tasksReminderTimes: [DateTime(1970, 1, 1, 8)],
          tasksReminderValues: [true],
        ).toJson(),
        equals(<String, dynamic>{
          'route': '/sign-in',
          'theme_mode_index': 0,
          'timeline_start_hour': 7,
          'timeline_end_hour': 22,
          'tasks_reminder_times': <Map<String, dynamic>>[
            <String, dynamic>{
              'year': 1970,
              'month': 1,
              'day': 1,
              'hour': 8,
              'minute': 0,
              'second': 0,
              'millisecond': 0,
              'microsecond': 0,
            },
          ],
          'tasks_reminder_values': <bool>[true],
        }),
      );
    });
  });
}
