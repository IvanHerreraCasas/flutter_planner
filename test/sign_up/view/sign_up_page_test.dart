import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpPage', () {
    late SignUpBloc signUpBloc;

    setUp(() {
      signUpBloc = MockSignUpBloc();

      when(() => signUpBloc.state).thenReturn(const SignUpState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signUpBloc,
        child: const SignUpPage(),
      );
    }

    testWidgets('renders SignUpLayoutBuilder with correct widgets',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SignUpLayoutBuilder), findsOneWidget);

      expect(find.byType(SignUpHeader), findsOneWidget);
      expect(find.byType(SignUpError), findsOneWidget);
      expect(find.byType(SignUpEmailTextField), findsOneWidget);
      expect(find.byType(SignUpPasswordTextField), findsOneWidget);
      expect(find.byType(SignUpButton), findsOneWidget);
      expect(find.byType(SignUpRedirection), findsOneWidget);
    });
  });
}
