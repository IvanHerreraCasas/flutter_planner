import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInButton', () {
    late SignInBloc signInBloc;

    setUp(() {
      signInBloc = MockSignInBloc();

      when(() => signInBloc.state).thenReturn(const SignInState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signInBloc,
        child: const SignInButton(),
      );
    }

    testWidgets('renders ElevatedButton with Sign in text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.widgetWithText(ElevatedButton, 'Sign in'),
        findsOneWidget,
      );
    });

    testWidgets('renders circular indicator when is loading', (tester) async {
      when(() => signInBloc.state).thenReturn(
        const SignInState(status: SignInStatus.loading),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets(
        'add SignInRequested '
        'to SignInBloc '
        'when is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(ElevatedButton));

      verify(() => signInBloc.add(const SignInRequested())).called(1);
    });
  });
}
