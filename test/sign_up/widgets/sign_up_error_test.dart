import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpError', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();

      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signUpBloc,
        child: const SignUpError(),
      );
    }

    testWidgets('renders only sizedbox when theres is not a failure',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('render correct error message when there is a failure',
        (tester) async {
      const errorMessage = 'error';
      when(() => signUpBloc.state).thenReturn(
        const SignUpState(
          status: SignUpStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
