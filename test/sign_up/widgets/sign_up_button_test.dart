import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpButton', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();

      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signUpBloc,
        child: const SignUpButton(),
      );
    }

    testWidgets('renders Elevated button with correct text when is not loading',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.widgetWithText(ElevatedButton, 'Sign up'), findsOneWidget);
    });

    testWidgets('renders progress indicator when is loading', (tester) async {
      when(() => signUpBloc.state).thenReturn(
        const SignUpState(status: SignUpStatus.loading),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'add SignUpRequested '
        'to SignUpBloc '
        'when is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(ElevatedButton));

      verify(() => signUpBloc.add(const SignUpRequested()));
    });
  });
}
