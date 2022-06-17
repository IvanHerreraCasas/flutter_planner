// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:routines_api/routines_api.dart';

void main() {
  group('ScheduleEvent', () {
    group('ScheduleSubscriptionRequested', () {
      final event = ScheduleSubscriptionRequested();
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

    group('ScheduleRoutineChanged', () {
      final routine = Routine(
        userID: 'userID',
        name: 'name',
        day: 1,
        startTime: DateTime(1970, 1, 1, 7),
        endTime: DateTime(1970, 1, 1, 10),
      );
      final event = ScheduleRoutineChanged(routine);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[routine]));
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
      final event = ScheduleSelectedRoutineChanged(routine);

      test('supports value equality', () {
        expect(
          event,
          equals(event),
        );
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[routine]));
      });
    });
  });
}
