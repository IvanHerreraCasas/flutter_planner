import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_api/authentication_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/app/router/app_router.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('AppRouter', () {
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

      when(() => authenticationBloc.state)
          .thenReturn(const AuthenticationState.unknown());
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => activitiesRepository.streamActivities(date: utcTodayDate))
          .thenAnswer((_) => const Stream.empty());
      when(() => tasksRepository.streamTasks(date: utcTodayDate))
          .thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    GoRouter buildSubject({String? initialLocation}) {
      return AppRouter.router(
        authenticationBloc: authenticationBloc,
        initialLocation: initialLocation,
      );
    }

    group('redirect', () {
      testWidgets(
          'redirects to SignInPage '
          'when user is not authenticated', (tester) async {
        await tester.pumpAppRouter(
          buildSubject(),
          authenticationBloc: authenticationBloc,
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
        );

        expect(find.byType(SignInPage), findsOneWidget);
      });

      testWidgets(
          'redirects to HomePage '
          'when user is authenticated', (tester) async {
        when(() => authenticationBloc.state).thenReturn(
          const AuthenticationState.authenticated(User(id: 'id')),
        );
        await tester.pumpAppRouter(
          buildSubject(initialLocation: '/sign-in'),
          authenticationBloc: authenticationBloc,
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
        );

        expect(find.byType(HomePage), findsOneWidget);
      });
    });

    group('routes', () {
      group('signUp', () {
        testWidgets('renders SignUpPage', (tester) async {
          await tester.pumpAppRouter(
            buildSubject(initialLocation: '/sign-up'),
            authenticationBloc: authenticationBloc,
          );

          expect(find.byType(SignUpPage), findsOneWidget);
        });
      });

      group('signIn', () {
        testWidgets('renders SignInPage', (tester) async {
          await tester.pumpAppRouter(
            buildSubject(initialLocation: '/sign-in'),
            authenticationBloc: authenticationBloc,
          );

          expect(find.byType(SignInPage), findsOneWidget);
        });
      });

      group('home', () {
        setUp(() {
          when(() => authenticationBloc.state).thenReturn(
            const AuthenticationState.authenticated(User(id: 'id')),
          );
        });
        testWidgets('renders HomePage', (tester) async {
          await tester.pumpAppRouter(
            buildSubject(initialLocation: '/home/planner'),
            authenticationBloc: authenticationBloc,
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          expect(find.byType(HomePage), findsOneWidget);
        });
        testWidgets(
            'renders PlannerPage '
            'when page param is planner', (tester) async {
          await tester.pumpAppRouter(
            buildSubject(initialLocation: '/home/planner'),
            authenticationBloc: authenticationBloc,
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          expect(find.byType(PlannerPage), findsOneWidget);
        });
        testWidgets(
            'renders SchedulePage '
            'when page param is schedule', (tester) async {
          await tester.pumpAppRouter(
            buildSubject(initialLocation: '/home/schedule'),
            authenticationBloc: authenticationBloc,
            activitiesRepository: activitiesRepository,
            routinesRepository: routinesRepository,
            tasksRepository: tasksRepository,
          );

          expect(find.byType(PlannerPage), findsOneWidget);
        });
      });
    });

    group('refresh', () {
      const mockUser = User(id: 'id');
      testWidgets(
          'renders HomePage '
          'when authState changes to authenticated', (tester) async {
        whenListen(
          authenticationBloc,
          Stream.fromIterable(const [
            AuthenticationState.unauthenticated(),
            AuthenticationState.authenticated(mockUser),
          ]),
        );
        await tester.pumpAppRouter(
          buildSubject(),
          authenticationBloc: authenticationBloc,
          activitiesRepository: activitiesRepository,
          routinesRepository: routinesRepository,
          tasksRepository: tasksRepository,
        );

        expect(find.byType(HomePage), findsOneWidget);
      });

      testWidgets(
          'renders SignInPage '
          'when authState changes to unAuthenticated', (tester) async {
        whenListen(
          authenticationBloc,
          Stream.fromIterable(const [
            AuthenticationState.authenticated(mockUser),
            AuthenticationState.unauthenticated(),
          ]),
        );
        await tester.pumpAppRouter(
          buildSubject(),
          authenticationBloc: authenticationBloc,
        );

        expect(find.byType(SignInPage), findsOneWidget);
      });
    });
  });
}
