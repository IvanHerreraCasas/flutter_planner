import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsOptions', () {
    late GoRouter goRouter;
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      goRouter = MockGoRouter();
      appBloc = MockAppBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
      when(() => appBloc.state).thenReturn(const AppState());
    });

    Widget buildSubject({
      SettingsSize currentSize = SettingsSize.large,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: authenticationBloc),
            BlocProvider.value(value: appBloc),
          ],
          child: SettingsOptions(
            currentSize: currentSize,
          ),
        ),
      );
    }

    group('My details', () {
      group('when size is small', () {
        testWidgets('renders Inkwell with My details text', (tester) async {
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
          );

          expect(find.widgetWithText(InkWell, 'My details'), findsOneWidget);
        });

        testWidgets(
            'goes to my details route and adds AppRouteChanged to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
          );

          await tester.tap(find.widgetWithText(InkWell, 'My details'));

          verify(
            () =>
                appBloc.add(const AppRouteChanged('/home/settings/my-details')),
          ).called(1);

          verify(
            () => goRouter.goNamed(
              AppRoutes.myDetails,
              params: {'page': 'settings'},
            ),
          ).called(1);
        });
      });
      group('when size is large', () {
        testWidgets('renders Inkwell with My details text', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.widgetWithText(InkWell, 'My details'), findsOneWidget);
        });

        testWidgets(
            'adds  AppSettingsIndex(0) to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.widgetWithText(InkWell, 'My details'));

          verify(
            () => appBloc.add(const AppSettingsIndexChanged(0)),
          ).called(1);
        });
      });
    });

    group('Appearance', () {
      group('when size is small', () {
        testWidgets('renders Inkwell with Appearance text', (tester) async {
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
          );

          expect(find.widgetWithText(InkWell, 'Appearance'), findsOneWidget);
        });
        testWidgets(
            'goes to appearance route and adds AppRouteChanged to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
          );

          await tester.tap(find.widgetWithText(InkWell, 'Appearance'));

          verify(
            () =>
                appBloc.add(const AppRouteChanged('/home/settings/appearance')),
          ).called(1);

          verify(
            () => goRouter.goNamed(
              AppRoutes.appearance,
              params: {'page': 'settings'},
            ),
          ).called(1);
        });
      });
      group('when size is large', () {
        testWidgets('renders Inkwell with Appearance text', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.widgetWithText(InkWell, 'Appearance'), findsOneWidget);
        });

        testWidgets(
            'adds  AppSettingsIndexChanged(1) to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.widgetWithText(InkWell, 'Appearance'));

          verify(
            () => appBloc.add(const AppSettingsIndexChanged(1)),
          ).called(1);
        });
      });
    });

    group('Log out ElevatedButton', () {
      testWidgets('is rendered when user is editable', (tester) async {
        when(() => authenticationBloc.state).thenReturn(
          const AuthenticationState.authenticated(User(id: 'id')),
        );
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, 'Log out'),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AuthenticationSignOutRequested to AuthenticationBloc '
          'when is pressed and size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));

        verify(
          () => authenticationBloc.add(const AuthenticationSignoutRequested()),
        ).called(1);
      });

      testWidgets(
          'adds AuthenticationSignOutRequested to AuthenticationBloc '
          'when is pressed and size is small', (tester) async {
        await tester.pumpApp(buildSubject(currentSize: SettingsSize.small));

        await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));

        verify(
          () => authenticationBloc.add(const AuthenticationSignoutRequested()),
        ).called(1);
      });
    });
  });
}
