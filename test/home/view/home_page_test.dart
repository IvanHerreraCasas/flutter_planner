import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_api/authentication_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

void main() {
  group('HomePage', () {
    late GoRouter goRouter;
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      goRouter = MockGoRouter();
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();
      tasksRepository = MockTasksRepository();
      appBloc = MockAppBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'userID')),
      );

      when(
        () => activitiesRepository.streamActivities(date: any(named: 'date')),
      ).thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => tasksRepository.streamTasks(date: any(named: 'date')))
          .thenAnswer((_) => const Stream.empty());
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
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

    testWidgets('renders HomeLayoutBuilder', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      expect(find.byType(HomeLayoutBuilder), findsOneWidget);
    });

    testWidgets('renders HomeBody', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      expect(find.byType(HomeBody), findsOneWidget);
    });

    testWidgets('renders appbar when is small', (tester) async {
      await tester.pumpApp(
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: HomeBreakpoints.small - 10,
          ),
          child: buildSubject(),
        ),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('renders HomeDrawer when is small', (tester) async {
      await tester.pumpApp(
        ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: HomeBreakpoints.small - 10,
          ),
          child: buildSubject(),
        ),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      await tester.dragFrom(Offset.zero, const Offset(200, 0));

      await tester.pump();

      expect(find.byType(HomeDrawer), findsOneWidget);
    });

    testWidgets('renders HomeNavRail when is not small', (tester) async {
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
      );

      expect(find.byType(HomeNavRail), findsOneWidget);
    });
  });
}
