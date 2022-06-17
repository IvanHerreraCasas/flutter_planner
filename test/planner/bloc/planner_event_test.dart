// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:table_calendar/table_calendar.dart';

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

    group('PlannerActivitiesUpdated', () {
      final event = PlannerActivitiesUpdated();
      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('PlannerSelectedDayChanged', () {
      final selectedDay = DateTime.utc(2022, 5, 25);
      final event = PlannerSelectedDayChanged(selectedDay);
      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[selectedDay]));
      });
    });

    group('PlannerFocusedDayChanged', () {
      final focusedDay = DateTime.utc(2022, 5, 25);
      final event = PlannerFocusedDayChanged(focusedDay);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[focusedDay]));
      });
    });

    group('PlannerCalendarFormatChanged', () {
      const format = CalendarFormat.week;
      final event = PlannerCalendarFormatChanged(format);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[format]));
      });
    });

    group('PlannerSizeChanged', () {
      const plannerSize = PlannerSize.medium;
      final event = PlannerSizeChanged(plannerSize);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[plannerSize]));
      });
    });

    group('PlannerAddRoutines', () {
      final event = PlannerAddRoutines();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('supports value equality', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
