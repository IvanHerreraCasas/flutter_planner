import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MyDetailsUserName', () {
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

    Widget buildSubject({String initialUserName = ''}) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: authenticationBloc),
          BlocProvider.value(value: myDetailsBloc)
        ],
        child: MyDetailsUserName(initialUserName: initialUserName),
      );
    }

    testWidgets('renders user name title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('User name'), findsOneWidget);
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
        'adds MyDetailsUserNameChanged to MyDetailsBloc '
        'when a new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(find.byType(TextField), 'new name');

      verify(
        () => myDetailsBloc.add(const MyDetailsUserNameChanged('new name')),
      ).called(1);
    });

    testWidgets(
        'adds MyDetailsUserNameSaved to MyDetailsBloc '
        'when a new value is submitted', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(find.byType(TextField), 'new name');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      verify(
        () => myDetailsBloc.add(const MyDetailsUserNameSaved()),
      ).called(1);
    });
  });
}
