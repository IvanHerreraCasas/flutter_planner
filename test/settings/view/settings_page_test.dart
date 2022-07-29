import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  late AppBloc appBloc;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    authenticationBloc = MockAuthenticationBloc();
    appBloc = MockAppBloc();

    when(() => appBloc.state).thenReturn(const AppState());
    when(() => authenticationBloc.state).thenReturn(
      const AuthenticationState.authenticated(User(id: 'id')),
    );
  });
  group('SettingsPage', () {
    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: appBloc),
        ],
        child: const SettingsPage(),
      );
    }

    testWidgets('renders SettingsView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SettingsView), findsOneWidget);
    });
  });
  group('SettingsView', () {
    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: appBloc),
        ],
        child: const SettingsView(),
      );
    }

    group('SettingsLayoutBuilder', () {
      final optionFinder = find.byType(SettingsOptions);
      final bodyFinder = find.byType(SettingsBody);

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(SettingsLayoutBuilder), findsOneWidget);
      });

      testWidgets(
          'renders correct small size widgets '
          'when width is less or equal than 576', (tester) async {
        await tester.binding.setSurfaceSize(const Size(576, 600));

        await tester.pumpApp(buildSubject());

        final options = tester.widget<SettingsOptions>(optionFinder);

        expect(options.currentSize, SettingsSize.small);
      });

      testWidgets(
          'render correct large size widgets '
          'when width is greater than 576', (tester) async {
        await tester.binding.setSurfaceSize(const Size(800, 600));

        await tester.pumpApp(buildSubject());

        final options = tester.widget<SettingsOptions>(optionFinder);

        expect(options.currentSize, SettingsSize.large);
        expect(bodyFinder, findsOneWidget);
      });
    });
  });
}
