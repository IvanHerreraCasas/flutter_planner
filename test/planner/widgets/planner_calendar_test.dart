import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerCalendar', () {
    late PlannerBloc plannerBloc;
    final currentDateTime = DateTime.now();
    final utcTodayDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );

    setUp(() {
      plannerBloc = MockPlannerBloc();

      when(() => plannerBloc.state).thenReturn(PlannerState());
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.large,
    }) {
      return BlocProvider.value(
        value: plannerBloc,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 400,
            maxHeight: 350,
          ),
          child: PlannerCalendar(currentSize: currentSize),
        ),
      );
    }

    testWidgets('renders TableCalendar with correct properties',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TableCalendar<Object?>), findsOneWidget);

      final tableCalendar = tester.widget<TableCalendar<Object?>>(
        find.byType(TableCalendar<Object?>),
      );

      expect(tableCalendar.calendarFormat, CalendarFormat.month);
      expect(tableCalendar.focusedDay, utcTodayDate);
    });

    testWidgets(
        'add PlannerSelectedDayChanged '
        'and PlannerFocusedDayChanged '
        'to PlannerBloc '
        'when a day is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.text('15'));

      verify(
        () => plannerBloc.add(
          PlannerSelectedDayChanged(
            DateTime.utc(
              currentDateTime.year,
              currentDateTime.month,
              15,
            ),
          ),
        ),
      ).called(1);

      verify(
        () => plannerBloc.add(
          PlannerFocusedDayChanged(
            DateTime.utc(
              currentDateTime.year,
              currentDateTime.month,
              15,
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'add PlannerFocusedDayChanged '
        'to PlannerBloc '
        'when page changes', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.drag(
        find.byType(TableCalendar<Object?>),
        const Offset(-500, 0),
      );

      verify(
        () => plannerBloc.add(
          PlannerFocusedDayChanged(
            DateTime.utc(
              currentDateTime.year,
              currentDateTime.month + 1,
            ),
          ),
        ),
      ).called(1);
    });
  });
}
