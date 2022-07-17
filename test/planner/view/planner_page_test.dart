import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_api/authentication_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerPage', () {
    late AuthenticationBloc authenticationBloc;
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;

    setUp(() {
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

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'userID')),
      );
      when(() => activitiesRepository.streamActivities(date: utcTodayDate))
          .thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => tasksRepository.streamTasks(date: utcTodayDate)).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: authenticationBloc,
        child: const PlannerPage(),
      );
    }

    testWidgets(
        'renders PlannerLayoutBuilder '
        'with correct widgets', (tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      expect(find.byType(PlannerLayoutBuilder), findsOneWidget);

      expect(find.byType(PlannerActivitiesHeader), findsOneWidget);
      expect(find.byType(PlannerCalendar), findsOneWidget);
      expect(find.byType(PlannerActivities), findsOneWidget);
      expect(find.byType(PlannerTasksHeader), findsOneWidget);
      expect(find.byType(PlannerTasks), findsOneWidget);
    });
  });
}
