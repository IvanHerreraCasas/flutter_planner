import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomeBody', () {
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;
    late RemindersRepository remindersRepository;

    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();
      remindersRepository = MockRemindersRepository();
      tasksRepository = MockTasksRepository();
      authenticationBloc = MockAuthenticationBloc();

      appBloc = MockAppBloc();

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
      when(() => remindersRepository.areAllowed).thenReturn(true);
    });

    Widget buildSubject({
      int index = 0,
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: appBloc),
        ],
        child: HomeBody(index: index),
      );
    }

    testWidgets('renders and show PlannerPager when index is 0',
        (tester) async {
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
        remindersRepository: remindersRepository,
      );

      expect(find.byType(PlannerPage), findsOneWidget);
    });

    testWidgets('renders and shows SchedulePage when index is 1',
        (tester) async {
      await tester.pumpApp(
        buildSubject(index: 1),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
        remindersRepository: remindersRepository,
      );

      expect(find.byType(SchedulePage), findsOneWidget);
    });

    testWidgets('renders and shows SettingsPage when index is 2',
        (tester) async {
      await tester.pumpApp(
        buildSubject(index: 1),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
        remindersRepository: remindersRepository,
      );

      expect(find.byType(SettingsPage), findsOneWidget);
    });
  });
}
