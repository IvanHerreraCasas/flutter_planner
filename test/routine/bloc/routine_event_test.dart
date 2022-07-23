// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoutineEvent', () {
    group('RoutineNameChanged', () {
      const name = 'name';

      test('supports value equality', () {
        expect(
          RoutineNameChanged(name),
          equals(RoutineNameChanged(name)),
        );
      });

      test('props are correct', () {
        expect(RoutineNameChanged(name).props, equals(<Object?>[name]));
      });
    });

    group('RoutineDayChanged', () {
      const day = 2;

      test('supports value equality', () {
        expect(
          RoutineDayChanged(day),
          equals(RoutineDayChanged(day)),
        );
      });

      test('props are correct', () {
        expect(RoutineDayChanged(day).props, equals(<Object?>[day]));
      });
    });

    group('RoutineStartTimeChanged', () {
      final startTime = DateTime(1970, 1, 1, 7);

      test('supports value equality', () {
        expect(
          RoutineStartTimeChanged(startTime),
          equals(RoutineStartTimeChanged(startTime)),
        );
      });

      test('props are correct', () {
        expect(
          RoutineStartTimeChanged(startTime).props,
          equals(<Object?>[startTime]),
        );
      });
    });

    group('RoutineEndTimeChanged', () {
      final endTime = DateTime(1970, 1, 1, 8);

      test('supports value equality', () {
        expect(
          RoutineEndTimeChanged(endTime),
          equals(RoutineEndTimeChanged(endTime)),
        );
      });

      test('props are correct', () {
        expect(
          RoutineEndTimeChanged(endTime).props,
          equals(<Object?>[endTime]),
        );
      });
    });

    group('RoutineSaved', () {
      test('supports value equality', () {
        expect(
          RoutineSaved(),
          equals(RoutineSaved()),
        );
      });

      test('props are correct', () {
        expect(RoutineSaved().props, equals(<Object?>[]));
      });
    });

    group('RoutineDeleted', () {
      test('supports value equality', () {
        expect(
          RoutineDeleted(),
          equals(RoutineDeleted()),
        );
      });

      test('props are correct', () {
        expect(RoutineDeleted().props, equals(<Object?>[]));
      });
    });
  });
}
