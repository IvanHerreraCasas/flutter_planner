import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScheduleSidePane', () {
    late ScheduleBloc scheduleBloc;

    final mockRoutine = Routine(
      userID: 'userID',
      name: 'name',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );

    setUp(() {
      scheduleBloc = MockScheduleBloc();

      when(() => scheduleBloc.state).thenReturn(
        ScheduleState(selectedRoutine: mockRoutine),
      );
    });

    Widget buildSubject({ScheduleSize currentSize = ScheduleSize.large}) {
      return BlocProvider.value(
        value: scheduleBloc,
        child: ScheduleSidePane(currentSize: currentSize),
      );
    }

    testWidgets(
        'renders a RoutinePage '
        'when selectedRoutine is not null and currentSize is not small',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(RoutinePage), findsOneWidget);
    });

    testWidgets(
        'renders SizedBox with non size '
        'when currentSize is small', (tester) async {
      await tester.pumpApp(buildSubject(currentSize: ScheduleSize.small));

      expect(find.byType(SizedBox), findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(find.byType(SizedBox));

      expect(renderBox.size, Size.zero);
    });

    testWidgets(
        'renders SizedBox with non size '
        'when selectedRoutine is null', (tester) async {
      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
      await tester.pumpApp(buildSubject());

      expect(find.byType(SizedBox), findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(find.byType(SizedBox));

      expect(renderBox.size, Size.zero);
    });

    group('Close icon button', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithIcon(IconButton, Icons.close),
          findsOneWidget,
        );
      });

      testWidgets(
          'add ScheduleSelectedRoutineChanged(null) '
          'to ScheduleBloc when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithIcon(IconButton, Icons.close));

        verify(
          () => scheduleBloc.add(
            const ScheduleSelectedRoutineChanged(null),
          ),
        );
      });
    });
  });
}
