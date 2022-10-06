import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerPage', () {
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;

    setUp(() {
      appBloc = MockAppBloc();
      authenticationBloc = MockAuthenticationBloc();
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();
      tasksRepository = MockTasksRepository();

      final currentDateTime = DateTime.now();
      final utcTodayDate = DateTime.utc(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
      );
      final lowerDate = DateTime.utc(utcTodayDate.year, utcTodayDate.month - 2);
      final upperDate = DateTime.utc(utcTodayDate.year, utcTodayDate.month + 2);

      when(() => appBloc.state).thenReturn(const AppState());
      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'userID')),
      );
      when(() => activitiesRepository.streamActivities(date: utcTodayDate))
          .thenAnswer(
        (_) => const Stream.empty(),
      );
      when(
        () => activitiesRepository.streamEvents(
          lower: lowerDate,
          upper: upperDate,
        ),
      ).thenAnswer((_) => const Stream.empty());
      when(() => tasksRepository.streamTasks(date: utcTodayDate)).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    group('PlannerPage', () {
      Widget buildSubject() {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authenticationBloc),
            BlocProvider.value(value: appBloc),
          ],
          child: const PlannerPage(),
        );
      }

      testWidgets('renders PlannerView', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
        );

        expect(find.byType(PlannerView), findsOneWidget);
      });
    });

    group('PlannerView', () {
      late PlannerBloc plannerBloc;

      setUp(() {
        plannerBloc = MockPlannerBloc();

        when(() => plannerBloc.state).thenReturn(PlannerState());
      });
      Widget buildSubject() {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authenticationBloc),
            BlocProvider.value(value: appBloc),
            BlocProvider.value(value: plannerBloc),
          ],
          child: const PlannerView(),
        );
      }

      group('PlannerLayoutBuilder', () {
        // finders
        final activitiesHeaderFinder = find.byType(PlannerActivitiesHeader);
        final tasksHeaderFinder = find.byType(PlannerTasksHeader);
        final calendarFinder = find.byType(PlannerCalendar);
        final activitiesFinder = find.byType(PlannerActivities);
        final tasksFinder = find.byType(PlannerTasks);
        final tabsFinder = find.byType(PlannerTabs);
        final fabFinder = find.byType(PlannerFab);

        testWidgets('is rendered.', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          expect(find.byType(PlannerLayoutBuilder), findsOneWidget);
        });

        testWidgets('unfocus when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          await tester.tap(find.byType(PlannerLayoutBuilder));

          final element = tester.element(find.byType(PlannerLayoutBuilder));

          expect(FocusScope.of(element).hasFocus, equals(false));
        });

        testWidgets(
            'renders correct small size widgets '
            'when width is less or equal than 400 pixels.', (tester) async {
          await tester.binding.setSurfaceSize(const Size(400, 600));

          await tester.pumpApp(buildSubject());

          final calendar = tester.widget<PlannerCalendar>(calendarFinder);

          final tabs = tester.widget<PlannerTabs>(tabsFinder);

          final activities = tester.widget<PlannerActivities>(activitiesFinder);

          expect(calendar.currentSize, PlannerSize.small);
          expect(tabs.currentSize, PlannerSize.small);
          expect(activities.currentSize, PlannerSize.small);
          expect(tasksFinder, findsOneWidget);
          expect(fabFinder, findsOneWidget);
        });

        testWidgets(
            'renders correct medium size widgets '
            'when width is less or equal than 660 pixels.', (tester) async {
          await tester.binding.setSurfaceSize(const Size(660, 600));

          await tester.pumpApp(buildSubject());

          final calendar = tester.widget<PlannerCalendar>(calendarFinder);

          final tabs = tester.widget<PlannerTabs>(tabsFinder);

          final activities = tester.widget<PlannerActivities>(activitiesFinder);

          expect(calendar.currentSize, PlannerSize.medium);
          expect(tabs.currentSize, PlannerSize.medium);
          expect(activities.currentSize, PlannerSize.medium);
          expect(tasksFinder, findsOneWidget);
          expect(fabFinder, findsOneWidget);
        });

        testWidgets(
            'renders correct large size widgets '
            'when width is greater than 660 pixels.', (tester) async {
          await tester.binding.setSurfaceSize(const Size(700, 600));

          await tester.pumpApp(buildSubject());

          final calendar = tester.widget<PlannerCalendar>(calendarFinder);

          final activities = tester.widget<PlannerActivities>(activitiesFinder);

          expect(calendar.currentSize, PlannerSize.large);
          expect(tasksHeaderFinder, findsOneWidget);
          expect(tasksFinder, findsOneWidget);
          expect(activitiesHeaderFinder, findsOneWidget);
          expect(activities.currentSize, PlannerSize.large);
        });
      });

      group('BlocListener', () {
        testWidgets('show SnackBar when status changes to failure',
            (tester) async {
          whenListen(
            plannerBloc,
            Stream.fromIterable([
              PlannerState(),
              PlannerState(status: PlannerStatus.failure, errorMessage: 'error')
            ]),
          );

          await tester.pumpApp(
            buildSubject(),
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          await tester.pump();

          expect(find.byType(SnackBar), findsOneWidget);
        });
      });
    });
  });
}
