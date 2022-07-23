import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpEmailTextField', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();

      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signUpBloc,
        child: const SignUpEmailTextField(),
      );
    }

    testWidgets('renders a TextField', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets(
        'add SignUpEmailChanged '
        'to SignUpBloc '
        'when new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      const newEmail = 'email@example.com';

      await tester.enterText(find.byType(TextField), newEmail);

      verify(() => signUpBloc.add(const SignUpEmailChanged(newEmail)))
          .called(1);
    });
  });
}
