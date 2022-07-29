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
  group('SettingsBody', () {
    late AuthenticationBloc authenticationBloc;
    late AppBloc appBloc;

    setUp(() {
      authenticationBloc = MockAuthenticationBloc();
      appBloc = MockAppBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
      when(() => appBloc.state).thenReturn(const AppState());
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
      await tester.pumpApp(buildSubject());

      expect(find.byType(MyDetailsPage), findsOneWidget);
    });

    testWidgets('renders AppearancePage when settingsIndex is 1',
        (tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      when(() => appBloc.state).thenReturn(
        const AppState(settingsIndex: 1),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(AppearancePage), findsOneWidget);
    });
  });
}
