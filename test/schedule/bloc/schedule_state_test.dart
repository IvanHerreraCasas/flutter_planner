// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routines_repository/routines_repository.dart';

void main() {
  group('ScheduleState', () {
    ScheduleState createSubject({
      ScheduleStatus status = ScheduleStatus.initial,
      List<Routine> routines = const [],
      Routine? selectedRoutine,
      String errorMessage = '',
    }) {
      return ScheduleState(
        status: status,
        routines: routines,
        selectedRoutine: selectedRoutine,
        errorMessage: errorMessage,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(
          <Object?>[
            ScheduleStatus.initial,
            const <Routine>[],
            null,
            '',
          ],
        ),
      );
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            routines: null,
            selectedRoutine: null,
            errorMessage: null,
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
            status: ScheduleStatus.failure,
            routines: [routine],
            selectedRoutine: () => routine,
            errorMessage: 'error',
          ),
          equals(
            createSubject(
              status: ScheduleStatus.failure,
              routines: [routine],
              selectedRoutine: routine,
              errorMessage: 'error',
            ),
          ),
        );
      });
    });
  });
}
