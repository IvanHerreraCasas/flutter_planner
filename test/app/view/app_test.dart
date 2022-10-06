import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  late AuthenticationRepository authenticationRepository;
  late ActivitiesRepository activitiesRepository;
  late RoutinesRepository routinesRepository;
  late TasksRepository tasksRepository;
  late RemindersRepository remindersRepository;

  setUp(() {
    final currentDateTime = DateTime.now();
    final utcTodayDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );

    final utcTomorrowDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day + 1,
    );
    authenticationRepository = MockAuthenticationRepository();
    activitiesRepository = MockActivitiesRepository();
    routinesRepository = MockRoutinesRepository();
    tasksRepository = MockTasksRepository();
    remindersRepository = MockRemindersRepository();
    when(
      () => tasksRepository.streamTasks(date: utcTodayDate),
    ).thenAnswer((_) => const Stream.empty());
    when(
      () => tasksRepository.streamTasks(date: utcTomorrowDate),
    ).thenAnswer((_) => const Stream.empty());
    when(() => remindersRepository.areAllowed).thenReturn(true);
  });

  group('App', () {
    setUp(() {
      when(() => authenticationRepository.status)
          .thenAnswer((_) => const Stream.empty());
    });
    testWidgets('renders AppView', (tester) async {
      await mockHydratedStorage(
        () => tester.pumpWidget(
          App(
            authenticationRepository: authenticationRepository,
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
            remindersRepository: remindersRepository,
          ),
        ),
      );

      expect(find.byType(AppView), findsOneWidget);
    });
  });

  group('AppView', () {
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
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

      when(() => authenticationRepository.status)
          .thenAnswer((_) => const Stream.empty());

      when(() => authenticationBloc.state)
          .thenReturn(const AuthenticationState.unknown());
      when(() => appBloc.state).thenReturn(const AppState());

      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => activitiesRepository.streamActivities(date: utcTodayDate))
          .thenAnswer((_) => const Stream.empty());
      when(
        () => activitiesRepository.streamEvents(
          lower: lowerDate,
          upper: upperDate,
        ),
      ).thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => tasksRepository.streamTasks(date: utcTodayDate))
          .thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => authenticationRepository,
          ),
          RepositoryProvider(
            create: (context) => activitiesRepository,
          ),
          RepositoryProvider(
            create: (context) => routinesRepository,
          ),
          RepositoryProvider(
            create: (context) => tasksRepository,
          ),
          RepositoryProvider(
            create: (context) => remindersRepository,
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => authenticationBloc),
            BlocProvider(create: (context) => appBloc),
          ],
          child: const AppView(),
        ),
      );
    }

    group('renders correct initial page', () {
      testWidgets(
        'if appState is default render SignInPage',
        (tester) async {
          await mockHydratedStorage(() => tester.pumpWidget(buildSubject()));

          expect(find.byType(SignInPage), findsOneWidget);
        },
      );

      testWidgets('renders the given route page of AppState', (tester) async {
        when(() => appBloc.state)
            .thenReturn(const AppState(route: '/home/planner'));
        when(() => authenticationBloc.state).thenReturn(
          const AuthenticationState.authenticated(User(id: 'id')),
        );
        await mockHydratedStorage(() => tester.pumpWidget(buildSubject()));

        expect(find.byType(PlannerPage), findsOneWidget);
      });
    });

    group('change route when authenticationStatus changes', () {
      testWidgets(
          'if status changes to authenticated, change route and navigate to /home/planner',
          (tester) async {
        whenListen<AuthenticationState>(
          authenticationBloc,
          Stream.fromIterable(const [
            AuthenticationState.unknown(),
            AuthenticationState.authenticated(User(id: 'id')),
          ]),
        );

        await mockHydratedStorage(() => tester.pumpWidget(buildSubject()));

        await tester.pumpAndSettle();

        verify(() => appBloc.add(const AppRouteChanged('/home/planner')));
        expect(find.byType(PlannerPage), findsOneWidget);
      });

      testWidgets(
          'if status changes to unauthenticated, change route and navigate to /sign-in',
          (tester) async {
        whenListen<AuthenticationState>(
          authenticationBloc,
          Stream.fromIterable(const [
            AuthenticationState.unknown(),
            AuthenticationState.unauthenticated(),
          ]),
        );

        await mockHydratedStorage(() => tester.pumpWidget(buildSubject()));

        await tester.pump();

        verify(() => appBloc.add(const AppRouteChanged('/sign-in')));
        expect(find.byType(SignInPage), findsOneWidget);
      });
    });
  });
}
