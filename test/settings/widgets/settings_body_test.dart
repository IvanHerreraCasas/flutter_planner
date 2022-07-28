import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SettingsBody', () {
    late AuthenticationBloc authenticationBloc;
    late SettingsBloc settingsBloc;

    setUp(() {
      authenticationBloc = MockAuthenticationBloc();
      settingsBloc = MockSettingsBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
      when(() => settingsBloc.state).thenReturn(const SettingsState());
    });

    Widget buildSubject() {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: settingsBloc),
        ],
        child: const SettingsBody(),
      );
    }

    testWidgets('renders MyDetailsPage when selectedIndex is 0',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(MyDetailsPage), findsOneWidget);
    });
  });
}
