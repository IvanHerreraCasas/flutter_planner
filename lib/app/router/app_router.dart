import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/helpers/helpers.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';

abstract class AppRouter {
  static GoRouter router({
    required AuthenticationBloc authenticationBloc,
    String? initialLocation,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      routes: [
        // '/'
        GoRoute(
          path: '/',
          redirect: (context, state) => '/home/planner',
        ),
        // signUp
        GoRoute(
          path: '/sign-up',
          name: AppRoutes.signUp,
          builder: (context, state) => BlocProvider(
            create: (context) => SignUpBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
            child: const SignUpPage(),
          ),
        ),
        // signIn
        GoRoute(
          path: '/sign-in',
          name: AppRoutes.signIn,
          builder: (context, state) => BlocProvider(
            create: (context) => SignInBloc(
              authenticationRepository:
                  context.read<AuthenticationRepository>(),
            ),
            child: const SignInPage(),
          ),
        ),
        // home
        GoRoute(
          path: '/home/:page',
          name: AppRoutes.home,
          builder: (context, state) {
            var index = 0;
            switch (state.params['page']) {
              case 'planner':
                index = 0;
                break;
              case 'schedule':
                index = 1;
                break;
              case 'settings':
                index = 2;
                break;
            }
            return HomePage(homeViewKey: state.pageKey, index: index);
          },
          routes: [
            // activity
            GoRoute(
              path: 'activity',
              name: AppRoutes.activity,
              builder: (context, state) => BlocProvider(
                create: (context) => ActivityBloc(
                  remindersRepository: context.read<RemindersRepository>(),
                  activitiesRepository: context.read<ActivitiesRepository>(),
                  initialActivity: state.extra! as Activity,
                ),
                child: const ActivityPage(),
              ),
            ),
            // routine
            GoRoute(
              path: 'routine',
              name: AppRoutes.routine,
              builder: (context, state) => BlocProvider(
                create: (context) => RoutineBloc(
                  routinesRepository: context.read<RoutinesRepository>(),
                  initialRoutine: state.extra! as Routine,
                ),
                child: const RoutinePage(
                  isPage: true,
                ),
              ),
            ),
            // my_details
            GoRoute(
              path: 'my_details',
              name: AppRoutes.myDetails,
              builder: (context, state) => const MyDetailsPage(
                isPage: true,
              ),
            ),
            // appearance
            GoRoute(
              path: 'appearance',
              name: AppRoutes.appearance,
              builder: (context, state) => const AppearancePage(
                isPage: true,
              ),
            ),
            // settings reminders
            GoRoute(
              path: 'reminders',
              name: AppRoutes.settingsReminders,
              builder: (context, state) => const SettingsRemindersPage(
                isPage: true,
              ),
            ),
          ],
        ),
      ],
      refreshListenable: ListenableStream(authenticationBloc.stream),
      redirect: (context, state) {
        final isSignIn = state.location == '/sign-in';
        final isRegistering = state.location == '/sign-up';
        final isAuthenticated = authenticationBloc.state.status ==
            AuthenticationStatus.authenticated;

        if (isAuthenticated && (isSignIn || isRegistering)) {
          return '/home/planner';
        }

        if (!isAuthenticated && !isSignIn && !isRegistering) return '/sign-in';

        return null;
      },
    );
  }
}
