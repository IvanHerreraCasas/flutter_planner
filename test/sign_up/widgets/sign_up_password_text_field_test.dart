import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpPasswordTextField', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();

      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signUpBloc,
        child: const SignUpPasswordTextField(),
      );
    }

    group('TextField', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TextField), findsOneWidget);
      });

      testWidgets(
          'add SignUpPasswordChanged '
          'to SignUpBloc '
          'when a new value is entered', (tester) async {
        await tester.pumpApp(buildSubject());

        const newPassword = 'password';

        await tester.enterText(find.byType(TextField), newPassword);

        verify(
          () => signUpBloc.add(const SignUpPasswordChanged(newPassword)),
        ).called(1);
      });
    });

    group('IconButton', () {
      group('when password is visible', () {
        testWidgets('renders Icon.visibility', (tester) async {
          when(() => signUpBloc.state).thenReturn(
            const SignUpState(passwordVisibility: true),
          );
          await tester.pumpApp(buildSubject());

          expect(find.byIcon(Icons.visibility), findsOneWidget);
        });

        testWidgets(
            'add SignUpPasswordVisibilyChanged(false) '
            'to SignUpBloc '
            'when is pressed', (tester) async {
          when(() => signUpBloc.state).thenReturn(
            const SignUpState(passwordVisibility: true),
          );

          await tester.pumpApp(buildSubject());

          await tester.tap(find.byIcon(Icons.visibility));

          verify(
            () => signUpBloc.add(const SignUpPasswordVisibilityChanged(false)),
          );
        });
      });

      group('when password is not visible', () {
        testWidgets('renders Icon.visibility_off', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byIcon(Icons.visibility_off), findsOneWidget);
        });

        testWidgets(
            'add SignUpPasswordVisibilyChanged(true) '
            'to SignUpBloc '
            'when is pressed', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byIcon(Icons.visibility_off));

          verify(
            () => signUpBloc.add(const SignUpPasswordVisibilityChanged(true)),
          );
        });
      });
    });
  });
}
