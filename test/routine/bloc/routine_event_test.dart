// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RoutineEvent', () {
    group('RoutineNameChanged', () {
      const name = 'name';
      final event = RoutineNameChanged(name);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[name]));
      });
    });

    group('RoutineDayChanged', () {
      const day = 2;
      final event = RoutineDayChanged(day);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[day]));
      });
    });

    group('RoutineStartTimeChanged', () {
      final startTime = DateTime(1970, 1, 1, 7);
      final event = RoutineStartTimeChanged(startTime);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[startTime]));
      });
    });

    group('RoutineEndTimeChanged', () {
      final endTime = DateTime(1970, 1, 1, 8);
      final event = RoutineEndTimeChanged(endTime);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[endTime]));
      });
    });

    group('RoutineSaved', () {
      final event = RoutineSaved();

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('RoutineDeleted', () {
      final event = RoutineDeleted();

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
