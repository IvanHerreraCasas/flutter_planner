import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsBody', () {
    late AuthenticationBloc authenticationBloc;
    late AppBloc appBloc;
    late RemindersRepository remindersRepository;

    setUp(() {
      authenticationBloc = MockAuthenticationBloc();
      appBloc = MockAppBloc();
      remindersRepository = MockRemindersRepository();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
      when(() => appBloc.state).thenReturn(const AppState());
      when(() => remindersRepository.areAllowed).thenReturn(true);
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: appBloc),
        ],
        child: const SettingsBody(),
      );
    }

    testWidgets('renders MyDetailsPage when settingsIndex is 0',
        (tester) async {
      await tester.pumpApp(
        buildSubject(),
        remindersRepository: remindersRepository,
      );

      expect(find.byType(MyDetailsPage), findsOneWidget);
    });

    testWidgets('renders AppearancePage when settingsIndex is 1',
        (tester) async {
      when(() => appBloc.state).thenReturn(
        const AppState(settingsIndex: 1),
      );
      await tester.pumpApp(
        buildSubject(),
        remindersRepository: remindersRepository,
      );

      expect(find.byType(AppearancePage), findsOneWidget);
    });

    testWidgets(
        'renders SettingsRemindersPage when settingsIndex is 2 '
        'and reminders are allowed', (tester) async {
      when(() => appBloc.state).thenReturn(
        const AppState(settingsIndex: 2),
      );
      await tester.pumpApp(
        buildSubject(),
        remindersRepository: remindersRepository,
      );

      expect(find.byType(SettingsRemindersPage), findsOneWidget);
    });
  });
}
