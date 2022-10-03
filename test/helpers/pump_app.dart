// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/l10n/l10n.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:reminders_repository/reminders_repository.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import 'helpers.dart';

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    AuthenticationRepository? authenticationRepository,
    ActivitiesRepository? activitiesRepository,
    RoutinesRepository? routinesRepository,
    TasksRepository? tasksRepository,
    RemindersRepository? remindersRepository,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) =>
                authenticationRepository ?? MockAuthenticationRepository(),
          ),
          RepositoryProvider(
            create: (context) =>
                activitiesRepository ?? MockActivitiesRepository(),
          ),
          RepositoryProvider(
            create: (context) => routinesRepository ?? MockRoutinesRepository(),
          ),
          RepositoryProvider(
            create: (context) => tasksRepository ?? MockTasksRepository(),
          ),
          RepositoryProvider(
            create: (context) =>
                remindersRepository ?? MockRemindersRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: widget,
          ),
        ),
      ),
    );
  }

  Future<void> pumpAppRouter(
    GoRouter router, {
    required AuthenticationBloc authenticationBloc,
    required AppBloc appBloc,
    AuthenticationRepository? authenticationRepository,
    ActivitiesRepository? activitiesRepository,
    RoutinesRepository? routinesRepository,
    TasksRepository? tasksRepository,
    RemindersRepository? remindersRepository,
  }) {
    return pumpWidget(
      MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) =>
                authenticationRepository ?? MockAuthenticationRepository(),
          ),
          RepositoryProvider(
            create: (context) =>
                activitiesRepository ?? MockActivitiesRepository(),
          ),
          RepositoryProvider(
            create: (context) => routinesRepository ?? MockRoutinesRepository(),
          ),
          RepositoryProvider(
            create: (context) => tasksRepository ?? MockTasksRepository(),
          ),
          RepositoryProvider(
            create: (context) =>
                remindersRepository ?? MockRemindersRepository(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authenticationBloc),
            BlocProvider.value(value: appBloc),
          ],
          child: MaterialApp.router(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
          ),
        ),
      ),
    );
  }
}
