import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../routine_mocks.dart';

void main() {
  group('RoutinePage', () {
    late RoutineBloc routineBloc;
    late ScheduleBloc scheduleBloc;
    late GoRouter goRouter;

    setUp(() {
      routineBloc = MockRoutineBloc();
      scheduleBloc = MockScheduleBloc();
      goRouter = MockGoRouter();

      when(() => routineBloc.state).thenReturn(mockRoutineState);
    });

    Widget buildSubject({
      bool isPage = false,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: routineBloc),
            BlocProvider.value(value: scheduleBloc),
          ],
          child: RoutinePage(
            isPage: isPage,
          ),
        ),
      );
    }

    testWidgets('renders RoutineLayoutBuilder with correct widgets',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(RoutineLayoutBuilder), findsOneWidget);

      expect(find.byType(RoutineHeaderButtons), findsOneWidget);
      expect(find.byType(RoutineNameTextField), findsOneWidget);
      expect(find.byType(RoutineDayPicker), findsOneWidget);
      expect(find.byType(RoutineTimePickers), findsOneWidget);
    });

    group('BlocListener', () {
      testWidgets('shows indicator when status change to loading',
          (tester) async {
        whenListen(
          routineBloc,
          Stream.fromIterable([
            mockRoutineState,
            mockRoutineState.copyWith(status: RoutineStatus.loading),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      testWidgets(
          'hide indicator and pop when status change to success '
          'and is a page', (tester) async {
        whenListen(
          routineBloc,
          Stream.fromIterable([
            mockRoutineState.copyWith(status: RoutineStatus.loading),
            mockRoutineState.copyWith(status: RoutineStatus.success),
          ]),
        );

        await tester.pumpApp(buildSubject(isPage: true));

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);

        verify(() => goRouter.pop()).called(1);
      });

      testWidgets(
          'hide indicator '
          'and add ScheduleSelectedRoutineChanged to ScheduleBloc '
          'when status change to success '
          'and is not a page', (tester) async {
        whenListen(
          routineBloc,
          Stream.fromIterable([
            mockRoutineState.copyWith(status: RoutineStatus.loading),
            mockRoutineState.copyWith(status: RoutineStatus.success),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsNothing);

        verify(
          () => scheduleBloc.add(const ScheduleSelectedRoutineChanged(null)),
        ).called(1);
      });

      testWidgets(
          'hide indicator and shows snackbar '
          'when status change to failure', (tester) async {
        whenListen(
          routineBloc,
          Stream.fromIterable([
            mockRoutineState.copyWith(status: RoutineStatus.loading),
            mockRoutineState.copyWith(status: RoutineStatus.failure),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });
  });
}
