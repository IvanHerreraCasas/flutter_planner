import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../routine_mocks.dart';

void main() {
  group('RoutineTimePickers', () {
    late RoutineBloc routineBloc;

    setUp(() {
      routineBloc = MockRoutineBloc();

      when(() => routineBloc.state).thenReturn(mockRoutineState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: routineBloc,
        child: const RoutineTimePickers(),
      );
    }

    group('start time picker', () {
      final startTime = mockRoutineState.startTime;
      const key = Key('start time picker');
      final startTimePickerFinder = find.byKey(key);

      testWidgets('is rendered with correct time', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(startTimePickerFinder, findsOneWidget);
        final startTimePicker =
            tester.widget(startTimePickerFinder) as DropdownTimePicker;

        expect(startTimePicker.time, equals(startTime));
      });

      testWidgets(
          'add RotuineStartTimeChanged '
          'to RoutineBloc '
          'when new hour is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        const newHour = 6;
        assert(
          newHour != startTime.hour,
          'new hour must be different from actual hour',
        );

        // tap actual hour
        await tester.tap(
          find.descendant(
            of: startTimePickerFinder,
            matching: find.text(startTime.hour.toString()).hitTestable(),
          ),
        );

        final newHourFinder = find.text(newHour.toString()).hitTestable();

        await tester.pump();

        // tap new hour
        await tester.ensureVisible(newHourFinder);

        await tester.pumpAndSettle();

        await tester.tap(newHourFinder);

        final newTime = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
          newHour,
          startTime.minute,
        );

        verify(() => routineBloc.add(RoutineStartTimeChanged(newTime)))
            .called(1);
      });

      testWidgets(
          'add RoutineStartTime changed '
          'to RoutineBloc '
          'when new minute is selected', (tester) async {
        const newMinute = 30;
        assert(
          newMinute != startTime.minute,
          'newMinute must be different from actual minute',
        );

        await tester.pumpApp(buildSubject());

        final actualMinute = (startTime.minute ~/ 10) * 10;

        // taps actual minute
        await tester.tap(
          find.descendant(
            of: startTimePickerFinder,
            matching: find.text(actualMinute.toString()).hitTestable(),
          ),
        );

        await tester.pump();

        final newMinuteFinder = find.text(newMinute.toString()).hitTestable();

        await tester.ensureVisible(newMinuteFinder);

        await tester.pumpAndSettle();

        // tap new minute
        await tester.tap(newMinuteFinder);

        final newTime = DateTime(
          startTime.year,
          startTime.month,
          startTime.day,
          startTime.hour,
          newMinute,
        );

        verify(() => routineBloc.add(RoutineStartTimeChanged(newTime)))
            .called(1);
      });
    });

    group('end time picker', () {
      final endTime = mockRoutineState.endTime;
      const key = Key('end time picker');
      final endTimePickerFinder = find.byKey(key);

      testWidgets('is rendered with correct time', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(endTimePickerFinder, findsOneWidget);
        final endTimePicker =
            tester.widget(endTimePickerFinder) as DropdownTimePicker;
        expect(endTimePicker.time, equals(endTime));
      });

      testWidgets(
          'add RoutineEndTimeChanged '
          'to RoutineBloc '
          'when new hour is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        const newHour = 10;
        assert(
          newHour != endTime.hour,
          'new hour must be different from actual hour',
        );

        // tap actual hour
        await tester.tap(
          find.descendant(
            of: endTimePickerFinder,
            matching: find.text(endTime.hour.toString()).hitTestable(),
          ),
        );

        await tester.pump();

        final newHourFinder = find.text(newHour.toString()).hitTestable();

        await tester.ensureVisible(newHourFinder);

        await tester.pumpAndSettle();

        // tap new hour
        await tester.tap(newHourFinder);

        final newTime = DateTime(
          endTime.year,
          endTime.month,
          endTime.day,
          newHour,
          endTime.minute,
        );

        verify(() => routineBloc.add(RoutineEndTimeChanged(newTime))).called(1);
      });

      testWidgets(
          'add RoutineEndTimeChanged '
          'to RoutineBloc '
          'when new minute is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        const newMinute = 30;
        assert(
          newMinute != endTime.minute,
          'new hour must be different from actual minute',
        );

        // tap actual minute
        await tester.tap(
          find.descendant(
            of: endTimePickerFinder,
            matching: find.text(endTime.minute.toString()).hitTestable(),
          ),
        );

        await tester.pump();

        final newMinuteFinder = find.text(newMinute.toString()).hitTestable();

        await tester.ensureVisible(newMinuteFinder);

        await tester.pumpAndSettle();

        // tap new hour
        await tester.tap(newMinuteFinder);

        final newTime = DateTime(
          endTime.year,
          endTime.month,
          endTime.day,
          endTime.hour,
          newMinute,
        );

        verify(() => routineBloc.add(RoutineEndTimeChanged(newTime))).called(1);
      });
    });
  });
}
