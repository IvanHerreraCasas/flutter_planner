import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MyDetailsEmail', () {
    late AuthenticationBloc authenticationBloc;
    late MyDetailsBloc myDetailsBloc;

    const mockUser = User(id: 'id');

    setUp(() {
      authenticationBloc = MockAuthenticationBloc();
      myDetailsBloc = MockMyDetailsBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(mockUser),
      );
    });

    Widget buildSubject({String initialEmail = ''}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: myDetailsBloc)
        ],
        child: MyDetailsEmail(initialEmail: initialEmail),
      );
    }

    testWidgets('renders email title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Email'), findsOneWidget);
    });

    testWidgets('renders a TextField', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('is disabled when user is not editable', (tester) async {
      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(
          User(id: 'id', isEditable: false),
        ),
      );
      await tester.pumpApp(buildSubject());

      final textField = tester.widget<TextField>(find.byType(TextField));

      expect(textField.enabled, equals(false));
    });

    testWidgets(
        'adds MyDetailsEmailChanged to MyDetailsBloc '
        'when a new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(find.byType(TextField), 'email@example.com');

      verify(
        () => myDetailsBloc.add(
          const MyDetailsEmailChanged('email@example.com'),
        ),
      ).called(1);
    });

    testWidgets(
        'adds MyDetailsEmailSaved to MyDetailsBloc '
        'when a new value is submitted', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(find.byType(TextField), 'email@example.com');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(
        () => myDetailsBloc.add(const MyDetailsEmailSaved()),
      ).called(1);
    });
  });
}
