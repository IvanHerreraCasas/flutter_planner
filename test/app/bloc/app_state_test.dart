// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    AppState createSubject({
      String route = '/sign-in',
      int themeModeIndex = 0,
      int settingIndex = 0,
    }) {
      return AppState(
        route: route,
        themeModeIndex: themeModeIndex,
        settingsIndex: settingIndex,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(['/sign-in', 0, 0]));
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
          ),
          equals(
            createSubject(
              route: '/home',
              themeModeIndex: 1,
              settingIndex: 1,
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
        }),
        equals(createSubject(route: '/home', themeModeIndex: 1)),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject().toJson(),
        equals(<String, dynamic>{
          'route': '/sign-in',
          'theme_mode_index': 0,
        }),
      );
    });
  });
}
