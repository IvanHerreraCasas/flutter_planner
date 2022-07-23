import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInEmailTextField', () {
    late SignInBloc signInBloc;

    setUp(() {
      signInBloc = MockSignInBloc();

      when(() => signInBloc.state).thenReturn(const SignInState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signInBloc,
        child: const SignInEmailTextField(),
      );
    }

    testWidgets('renders TextField', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets(
        'add SignInEmailChanged '
        'to SignInBloc '
        'when new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      const newEmail = 'email@example.com';

      await tester.enterText(find.byType(TextField), newEmail);

      verify(
        () => signInBloc.add(const SignInEmailChanged(newEmail)),
      ).called(1);
    });
  });
}
