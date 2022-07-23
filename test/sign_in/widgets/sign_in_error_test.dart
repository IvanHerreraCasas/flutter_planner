import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInError', () {
    late SignInBloc signInBloc;

    setUp(() {
      signInBloc = MockSignInBloc();

      when(() => signInBloc.state).thenReturn(const SignInState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signInBloc,
        child: const SignInError(),
      );
    }

    testWidgets('renders only SizedBox when status is not failure',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SizedBox), findsOneWidget);
      expect(find.byType(Text), findsNothing);
    });

    testWidgets('renders errorMessage when status is failure', (tester) async {
      const errorMessage = 'error';
      when(() => signInBloc.state).thenReturn(
        const SignInState(
          status: SignInStatus.failure,
          errorMessage: errorMessage,
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.text(errorMessage), findsOneWidget);
    });
  });
}
