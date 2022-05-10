// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_api/authentication_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/l10n/l10n.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:routines_repository/routines_repository.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
    required this.activitiesRepository,
    required this.routinesRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;
  final ActivitiesRepository activitiesRepository;
  final RoutinesRepository routinesRepository;

  @override
  Widget build(BuildContext context) {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (context) => AppBloc(),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          redirect: (state) => '/home/planner',
        ),
        HomePage.route(),
        SignInPage.route(),
        SignUpPage.route(),
      ],
      initialLocation: context.read<AppBloc>().state.route,
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(
        scheme: FlexScheme.flutterDash,
        fontFamily: GoogleFonts.lato().fontFamily,
        blendLevel: 6,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.flutterDash,
        fontFamily: GoogleFonts.lato().fontFamily,
        blendLevel: 3,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routeInformationParser: _router.routeInformationParser,
      routerDelegate: _router.routerDelegate,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            switch (state.status) {
              case AuthenticationStatus.unknown:
                break;
              case AuthenticationStatus.authenticated:
                _router.go('/home/planner');
                context
                    .read<AppBloc>()
                    .add(const AppRouteChanged('/home/planner'));
                break;
              case AuthenticationStatus.unauthenticated:
                _router.go('/sign-in');
                context.read<AppBloc>().add(const AppRouteChanged('/sign-in'));
                break;
            }
          },
          child: child,
        );
      },
    );
  }
}
