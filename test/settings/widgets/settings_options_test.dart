import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsOptions', () {
    late GoRouter goRouter;
    late AppBloc appBloc;
    late AuthenticationBloc authenticationBloc;
    late RemindersRepository remindersRepository;

    setUp(() {
      goRouter = MockGoRouter();
      appBloc = MockAppBloc();
      authenticationBloc = MockAuthenticationBloc();
      remindersRepository = MockRemindersRepository();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
      when(() => appBloc.state).thenReturn(const AppState());
      when(() => remindersRepository.areAllowed).thenReturn(true);
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
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'My details'), findsOneWidget);
        });

        testWidgets(
            'goes to my details route and adds AppRouteChanged to AppBloc '
            'when is pressed', (tester) async {
          when(
            () => goRouter.namedLocation(
              AppRoutes.myDetails,
              params: {'page': 'settings'},
            ),
          ).thenReturn('/home/settings/my_details');

          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
            remindersRepository: remindersRepository,
          );

          await tester.tap(find.widgetWithText(InkWell, 'My details'));

          verify(
            () => appBloc.add(
              const AppRouteChanged('/home/settings/my_details'),
            ),
          );

          verify(() => goRouter.go('/home/settings/my_details'));
        });
      });
      group('when size is large', () {
        testWidgets('renders Inkwell with My details text', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'My details'), findsOneWidget);
        });

        testWidgets(
            'adds  AppSettingsIndex(0) to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

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
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Appearance'), findsOneWidget);
        });
        testWidgets(
            'goes to appearance route and adds AppRouteChanged to AppBloc '
            'when is pressed', (tester) async {
          when(
            () => goRouter.namedLocation(
              AppRoutes.appearance,
              params: {'page': 'settings'},
            ),
          ).thenReturn('/home/settings/appearance');

          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
            remindersRepository: remindersRepository,
          );

          await tester.tap(find.widgetWithText(InkWell, 'Appearance'));

          verify(
            () => appBloc.add(
              const AppRouteChanged('/home/settings/appearance'),
            ),
          );

          verify(() => goRouter.go('/home/settings/appearance'));
        });
      });
      group('when size is large', () {
        testWidgets('renders Inkwell with Appearance text', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Appearance'), findsOneWidget);
        });

        testWidgets(
            'adds  AppSettingsIndexChanged(1) to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          await tester.tap(find.widgetWithText(InkWell, 'Appearance'));

          verify(
            () => appBloc.add(const AppSettingsIndexChanged(1)),
          ).called(1);
        });
      });
    });

    group('Reminders', () {
      group('when size is small', () {
        testWidgets(
            'renders Inkwell with Reminders text '
            'when reminders are allowed.', (tester) async {
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Reminders'), findsOneWidget);
        });

        testWidgets(
            'does not render Inkwell with Reminders text '
            'when reminders are not allowed.', (tester) async {
          when(() => remindersRepository.areAllowed).thenReturn(false);
          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Reminders'), findsNothing);
        });
        testWidgets(
            'goes to reminders route and adds AppRouteChanged to AppBloc '
            'when is pressed', (tester) async {
          when(
            () => goRouter.namedLocation(
              AppRoutes.settingsReminders,
              params: {'page': 'settings'},
            ),
          ).thenReturn('/home/settings/reminders');

          await tester.pumpApp(
            buildSubject(
              currentSize: SettingsSize.small,
            ),
            remindersRepository: remindersRepository,
          );

          await tester.tap(find.widgetWithText(InkWell, 'Reminders'));

          verify(
            () =>
                appBloc.add(const AppRouteChanged('/home/settings/reminders')),
          );

          verify(() => goRouter.go('/home/settings/reminders'));
        });
      });
      group('when size is large', () {
        testWidgets(
            'renders Inkwell with Reminders text '
            'when reminders are allowed.', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Reminders'), findsOneWidget);
        });

        testWidgets(
            'does not render Inkwell with Reminders text '
            'when reminders are not allowed.', (tester) async {
          when(() => remindersRepository.areAllowed).thenReturn(false);
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          expect(find.widgetWithText(InkWell, 'Reminders'), findsNothing);
        });

        testWidgets(
            'adds AppSettingsIndexChanged(2) to AppBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(
            buildSubject(),
            remindersRepository: remindersRepository,
          );

          await tester.tap(find.widgetWithText(InkWell, 'Reminders'));

          verify(
            () => appBloc.add(const AppSettingsIndexChanged(2)),
          ).called(1);
        });
      });
    });

    group('Log out ElevatedButton', () {
      testWidgets('is rendered when user is editable', (tester) async {
        when(() => authenticationBloc.state).thenReturn(
          const AuthenticationState.authenticated(User(id: 'id')),
        );
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

        expect(
          find.widgetWithText(ElevatedButton, 'Log out'),
          findsOneWidget,
        );
      });

      testWidgets(
          'adds AuthenticationSignOutRequested to AuthenticationBloc '
          'when is pressed and size is large', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));

        verify(
          () => authenticationBloc.add(const AuthenticationSignoutRequested()),
        ).called(1);
      });

      testWidgets(
          'adds AuthenticationSignOutRequested to AuthenticationBloc '
          'when is pressed and size is small', (tester) async {
        await tester.pumpApp(
          buildSubject(currentSize: SettingsSize.small),
          remindersRepository: remindersRepository,
        );

        await tester.tap(find.widgetWithText(ElevatedButton, 'Log out'));

        verify(
          () => authenticationBloc.add(const AuthenticationSignoutRequested()),
        ).called(1);
      });
    });
  });
}
