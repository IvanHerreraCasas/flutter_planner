// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routines_repository/routines_repository.dart';

void main() {
  group('RoutineState', () {
    final fakeStartTime = DateTime(1970, 1, 1, 7);
    final fakeEndTime = DateTime(1970, 1, 1, 8);
    final fakeInitialRoutine = Routine(
      userID: 'userID',
      name: 'name',
      day: 1,
      startTime: fakeStartTime,
      endTime: fakeEndTime,
    );

    RoutineState createSubject({
      RoutineStatus status = RoutineStatus.initial,
      Routine? initialRoutine,
      String name = 'name',
      int day = 1,
      DateTime? startTime,
      DateTime? endTime,
      String errorMessage = '',
    }) {
      return RoutineState(
        status: status,
        initialRoutine: initialRoutine ?? fakeInitialRoutine,
        name: name,
        day: day,
        startTime: startTime ?? fakeStartTime,
        endTime: endTime ?? fakeEndTime,
        errorMessage: errorMessage,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object?>[
          RoutineStatus.initial,
          fakeInitialRoutine,
          'name',
          1,
          fakeStartTime,
          fakeEndTime,
          '',
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            initialRoutine: null,
            name: null,
            day: null,
            startTime: null,
            endTime: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        const altDay = 2;
        final altStartTime = DateTime(1970, 1, 1, 9);
        final altEndTime = DateTime(1970, 1, 1, 11);
        final altInitialRoutine = Routine(
          userID: 'user-id',
          name: 'routine',
          day: altDay,
          startTime: altStartTime,
          endTime: altEndTime,
        );

        expect(
          createSubject().copyWith(
            status: RoutineStatus.loading,
            initialRoutine: altInitialRoutine,
            day: altDay,
            startTime: altStartTime,
            endTime: altEndTime,
            errorMessage: 'error',
          ),
          equals(
            createSubject(
              status: RoutineStatus.loading,
              initialRoutine: altInitialRoutine,
              day: altDay,
              startTime: altStartTime,
              endTime: altEndTime,
              errorMessage: 'error',
            ),
          ),
        );
      });
    });
  });
}
