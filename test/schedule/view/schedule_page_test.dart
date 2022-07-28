import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SchedulePage', () {
    late AppBloc appBloc;
    late RoutinesRepository routinesRepository;

    setUp(() {
      appBloc = MockAppBloc();
      routinesRepository = MockRoutinesRepository();

      when(() => appBloc.state).thenReturn(const AppState());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    group('SchedulePage', () {
      Widget buildSubject() {
        return BlocProvider.value(
          value: appBloc,
          child: const SchedulePage(),
        );
      }

      testWidgets('renders ScheduleView', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          routinesRepository: routinesRepository,
        );

        expect(find.byType(ScheduleView), findsOneWidget);
      });
    });

    group('ScheduleView', () {
      late ScheduleBloc scheduleBloc;

      setUp(() {
        scheduleBloc = MockScheduleBloc();

        when(() => scheduleBloc.state).thenReturn(const ScheduleState());
      });

      Widget buildSubject() {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc),
            BlocProvider.value(value: scheduleBloc),
          ],
          child: const ScheduleView(),
        );
      }

      testWidgets('renders ScheduleLayoutBuilder with correct widgets',
          (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(ScheduleLayoutBuilder), findsOneWidget);
        expect(find.byType(ScheduleHeader), findsOneWidget);
        expect(find.byType(ScheduleTimetable), findsOneWidget);
        expect(find.byType(ScheduleSidePane), findsOneWidget);
      });

      group('BlocListener', () {
        testWidgets('show SnackBar when status changes to failure',
            (tester) async {
          whenListen(
            scheduleBloc,
            Stream.fromIterable(const [
              ScheduleState(),
              ScheduleState(
                status: ScheduleStatus.failure,
                errorMessage: 'error',
              )
            ]),
          );

          await tester.pumpApp(buildSubject());

          await tester.pump();

          expect(find.byType(SnackBar), findsOneWidget);
        });
      });
    });
  });
}
