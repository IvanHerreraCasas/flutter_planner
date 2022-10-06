import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    late GoRouter goRouter;
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;
    late RemindersRepository remindersRepository;
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      goRouter = MockGoRouter();
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();
      tasksRepository = MockTasksRepository();
      remindersRepository = MockRemindersRepository();
      appBloc = MockAppBloc();
      authenticationBloc = MockAuthenticationBloc();

      final currentDateTime = DateTime.now();
      final utcTodayDate = DateTime.utc(
        currentDateTime.year,
        currentDateTime.month,
        currentDateTime.day,
      );
      final lowerDate = DateTime.utc(utcTodayDate.year, utcTodayDate.month - 2);
      final upperDate = DateTime.utc(utcTodayDate.year, utcTodayDate.month + 2);

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'userID')),
      );

      when(() => appBloc.state).thenReturn(const AppState());
      when(
        () => activitiesRepository.streamActivities(date: any(named: 'date')),
      ).thenAnswer((_) => const Stream.empty());
      when(
        () => activitiesRepository.streamEvents(
          lower: lowerDate,
          upper: upperDate,
        ),
      ).thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => tasksRepository.streamTasks(date: any(named: 'date')))
          .thenAnswer((_) => const Stream.empty());
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
      when(() => remindersRepository.areAllowed).thenReturn(false);
    });

    Widget buildSubject({
      int index = 0,
      Key? homeViewKey,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: appBloc),
            BlocProvider.value(value: authenticationBloc),
          ],
          child: HomePage(
            index: index,
            homeViewKey: homeViewKey,
          ),
        ),
      );
    }

    group('HomeLayoutBuilder', () {
      //finders
      final appBarFinder = find.byType(AppBar);
      final drawerFinder = find.byType(HomeDrawer);
      final bodyFinder = find.byType(HomeBody);
      final navRailFinder = find.byType(HomeNavRail);

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        );

        expect(find.byType(HomeLayoutBuilder), findsOneWidget);
      });

      testWidgets(
          'renders correct small size widgets '
          'when width is less or equal than 576 pixels.', (tester) async {
        await tester.binding.setSurfaceSize(const Size(576, 600));

        await tester.pumpApp(
          buildSubject(),
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        );

        await tester.dragFrom(Offset.zero, const Offset(200, 0));

        await tester.pump();

        expect(appBarFinder, findsOneWidget);
        expect(drawerFinder, findsOneWidget);
        expect(bodyFinder, findsOneWidget);
      });

      testWidgets(
          'renders correct medium size widgets '
          'when width is less or equal than 1200 pixels.', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1200, 600));

        await tester.pumpApp(
          buildSubject(),
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        );

        final navRail = tester.widget<HomeNavRail>(navRailFinder);

        expect(navRail.currentSize, HomeSize.medium);
        expect(bodyFinder, findsOneWidget);
      });

      testWidgets(
          'renders correct large size widgets '
          'when width is greater than 1200 pixels.', (tester) async {
        await tester.binding.setSurfaceSize(const Size(1300, 600));

        await tester.pumpApp(
          buildSubject(),
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
          remindersRepository: remindersRepository,
        );
        final navRail = tester.widget<HomeNavRail>(navRailFinder);

        expect(navRail.currentSize, HomeSize.large);
        expect(bodyFinder, findsOneWidget);
      });
    });
  });
}
