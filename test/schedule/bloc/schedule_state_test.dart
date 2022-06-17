// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routines_api/routines_api.dart';

void main() {
  group('PlannerState', () {
    ScheduleState createSubject({
      List<Routine> routines = const [],
      Routine? selectedRoutine,
    }) {
      return ScheduleState(
        routines: routines,
        selectedRoutine: selectedRoutine,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(<Object?>[const <Routine>[], null]));
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            routines: null,
            selectedRoutine: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        final routine = Routine(
          userID: 'userID',
          name: 'name',
          day: 1,
          startTime: DateTime(1970, 1, 1, 7),
          endTime: DateTime(1970, 1, 1, 10),
        );
        expect(
          createSubject().copyWith(
            routines: [routine],
            selectedRoutine: () => routine,
          ),
          equals(
            createSubject(routines: [routine], selectedRoutine: routine),
          ),
        );
      });
    });
  });
}
