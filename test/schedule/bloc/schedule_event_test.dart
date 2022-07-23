// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routines_repository/routines_repository.dart';

void main() {
  group('ScheduleEvent', () {
    group('ScheduleSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          ScheduleSubscriptionRequested(),
          equals(ScheduleSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(ScheduleSubscriptionRequested().props, equals(<Object?>[]));
      });
    });

    group('ScheduleRoutineChanged', () {
      final routine = Routine(
        userID: 'userID',
        name: 'name',
        day: 1,
        startTime: DateTime(1970, 1, 1, 7),
        endTime: DateTime(1970, 1, 1, 10),
      );

      test('supports value equality', () {
        expect(
          ScheduleRoutineChanged(routine),
          equals(ScheduleRoutineChanged(routine)),
        );
      });

      test('props are correct', () {
        expect(
          ScheduleRoutineChanged(routine).props,
          equals(<Object?>[routine]),
        );
      });
    });

    group('ScheduleSelectedRoutineChanged', () {
      final routine = Routine(
        userID: 'userID',
        name: 'name',
        day: 1,
        startTime: DateTime(1970, 1, 1, 7),
        endTime: DateTime(1970, 1, 1, 10),
      );

      test('supports value equality', () {
        expect(
          ScheduleSelectedRoutineChanged(routine),
          equals(ScheduleSelectedRoutineChanged(routine)),
        );
      });

      test('props are correct', () {
        expect(
          ScheduleSelectedRoutineChanged(routine).props,
          equals(<Object?>[routine]),
        );
      });
    });
  });
}
