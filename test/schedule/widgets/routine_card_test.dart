import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('RoutineCard', () {
    late ScheduleBloc scheduleBloc;
    late GoRouter goRouter;

    final mockRoutine = Routine(
      userID: 'userID',
      name: 'name',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );

    setUp(() {
      scheduleBloc = MockScheduleBloc();
      goRouter = MockGoRouter();
    });

    Widget buildSubject({
      Routine? routine,
      ScheduleSize currentSize = ScheduleSize.large,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: BlocProvider.value(
          value: scheduleBloc,
          child: RoutineCard(
            routine: routine ?? mockRoutine,
            currentSize: currentSize,
          ),
        ),
      );
    }

    testWidgets('renders the correct name', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('name'), findsOneWidget);
    });

    group('when is tapped', () {
      testWidgets(
          'add ScheduleSelectedRoutineChanged '
          'to ScheduleBloc '
          'when size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('name'));

        verify(
          () => scheduleBloc.add(ScheduleSelectedRoutineChanged(mockRoutine)),
        ).called(1);
      });

      testWidgets(
          'goes to RoutinePage '
          'and send the routine as extra '
          'when size is small', (tester) async {
        await tester.pumpApp(
          buildSubject(
            currentSize: ScheduleSize.small,
          ),
        );

        await tester.tap(find.text('name'));

        verify(
          () => goRouter.goNamed(
            AppRoutes.routine,
            params: {'page': 'schedule'},
            extra: mockRoutine,
          ),
        ).called(1);
      });
    });
  });
}
