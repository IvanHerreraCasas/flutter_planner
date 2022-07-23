import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInPasswordTextField', () {
    late SignInBloc signInBloc;

    setUp(() {
      signInBloc = MockSignInBloc();

      when(() => signInBloc.state).thenReturn(const SignInState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signInBloc,
        child: const SignInPasswordTextField(),
      );
    }

    group('TextField', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets(
          'add SignInPasswordChanged '
          'to SignInBloc '
          'when new value is entered', (tester) async {
        const newPassword = 'password';
        await tester.pumpApp(buildSubject());

        await tester.enterText(find.byType(TextField), newPassword);

        verify(
          () => signInBloc.add(const SignInPasswordChanged(newPassword)),
        ).called(1);
      });
    });

    group('IconButton', () {
      group('when password is visible', () {
        setUp(() {
          when(() => signInBloc.state).thenReturn(
            const SignInState(passwordVisibility: true),
          );
        });
        testWidgets('renders Icon.visibility', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byIcon(Icons.visibility), findsOneWidget);
        });

        testWidgets(
            'add SignInPasswordVisibilityChanged(false) '
            'to SignInBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byIcon(Icons.visibility));

          verify(
            () => signInBloc.add(const SignInPasswordVisibilityChanged(false)),
          ).called(1);
        });
      });

      group('when password is not visible', () {
        setUp(() {
          when(() => signInBloc.state).thenReturn(const SignInState());
        });
        testWidgets('renders Icon.visibility_off', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        });

        testWidgets(
            'add SignInPasswordVisibilityChanged(true) '
            'to SignInBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byIcon(Icons.visibility_off));

          verify(
            () => signInBloc.add(const SignInPasswordVisibilityChanged(true)),
          ).called(1);
        });
      });
    });
  });
}
