// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlannerEvent', () {
    group('PlannerSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          PlannerSubscriptionRequested(),
          equals(PlannerSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(PlannerSubscriptionRequested().props, equals(<Object?>[]));
      });
    });

    group('PlannerEventsSubRequested', () {
      test('supports value equality', () {
        expect(
          PlannerEventsSubRequested(),
          equals(PlannerEventsSubRequested()),
        );
      });

      test('props are correct', () {
        expect(PlannerEventsSubRequested().props, equals(<Object?>[]));
      });
    });

    group('PlannerTaskSubRequested', () {
      test('supports value equality', () {
        expect(
          PlannerTasksSubRequested(),
          equals(PlannerTasksSubRequested()),
        );
      });

      test('props are correct', () {
        expect(PlannerTasksSubRequested().props, equals(<Object?>[]));
      });
    });

    group('PlannerSelectedDayChanged', () {
      final selectedDay = DateTime.utc(2022, 5, 25);
      test('supports value equality', () {
        expect(
          PlannerSelectedDayChanged(selectedDay),
          equals(PlannerSelectedDayChanged(selectedDay)),
        );
      });

      test('props are correct', () {
        expect(
          PlannerSelectedDayChanged(selectedDay).props,
          equals(<Object?>[selectedDay]),
        );
      });
    });

    group('PlannerFocusedDayChanged', () {
      final focusedDay = DateTime.utc(2022, 5, 25);

      test('supports value equality', () {
        expect(
          PlannerFocusedDayChanged(focusedDay),
          equals(PlannerFocusedDayChanged(focusedDay)),
        );
      });

      test('props are correct', () {
        expect(
          PlannerFocusedDayChanged(focusedDay).props,
          equals(<Object?>[focusedDay]),
        );
      });
    });

    group('PlannerAddRoutines', () {
      test('supports value equality', () {
        expect(PlannerAddRoutines(), equals(PlannerAddRoutines()));
      });

      test('props are correct', () {
        expect(PlannerAddRoutines().props, equals(<Object?>[]));
      });
    });

    group('PlannerNewTaskAdded', () {
      test('supports value equality', () {
        expect(PlannerNewTaskAdded(), equals(PlannerNewTaskAdded()));
      });

      test('props are correct', () {
        expect(PlannerNewTaskAdded().props, equals(<Object?>[]));
      });
    });

    group('PlannerSelectedTabChanged', () {
      const selectedTab = 1;
      test('supports value equality', () {
        expect(
          PlannerSelectedTabChanged(selectedTab),
          equals(PlannerSelectedTabChanged(selectedTab)),
        );
      });

      test('props are correct', () {
        expect(
          PlannerSelectedTabChanged(selectedTab).props,
          equals(<Object?>[selectedTab]),
        );
      });
    });
  });
}
