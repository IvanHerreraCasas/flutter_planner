// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PlannerEvent', () {
    group('PlannerSubscriptionRequested', () {
      final event = PlannerSubscriptionRequested();
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

    group('PlannerTaskSubRequested', () {
      final event = PlannerTasksSubRequested();
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

    group('PlannerSelectedDayChanged', () {
      final selectedDay = DateTime.utc(2022, 5, 25);
      final event = PlannerSelectedDayChanged(selectedDay);
      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[selectedDay]));
      });
    });

    group('PlannerFocusedDayChanged', () {
      final focusedDay = DateTime.utc(2022, 5, 25);
      final event = PlannerFocusedDayChanged(focusedDay);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[focusedDay]));
      });
    });

    group('PlannerAddRoutines', () {
      final event = PlannerAddRoutines();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('PlannerNewTaskAdded', () {
      final event = PlannerNewTaskAdded();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('PlannerSelectedTabChanged', () {
      const selectedTab = 1;
      final event = PlannerSelectedTabChanged(selectedTab);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[selectedTab]));
      });
    });
  });
}
