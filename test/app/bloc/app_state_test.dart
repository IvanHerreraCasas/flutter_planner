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
    }) {
      return AppState(
        route: route,
        themeModeIndex: themeModeIndex,
        settingsIndex: settingIndex,
        timelineStartHour: timelineStartHour,
        timelineEndHour: timelineEndHour,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(['/sign-in', 0, 0, 7, 22]));
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
          ),
          equals(
            createSubject(
              route: '/home',
              themeModeIndex: 1,
              settingIndex: 1,
              timelineStartHour: 8,
              timelineEndHour: 24,
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
        }),
        equals(
          createSubject(
            route: '/home',
            themeModeIndex: 1,
            timelineStartHour: 8,
            timelineEndHour: 24,
          ),
        ),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject().toJson(),
        equals(<String, dynamic>{
          'route': '/sign-in',
          'theme_mode_index': 0,
          'timeline_start_hour': 7,
          'timeline_end_hour': 22,
        }),
      );
    });
  });
}
