import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../sign_in_mocks.dart';

void main() {
  group('SignInPage', () {
    late SignInBloc signInBloc;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      signInBloc = MockSignInBloc();
      authenticationRepository = MockAuthenticationRepository();

      when(() => signInBloc.state).thenReturn(const SignInState());
      when(() => authenticationRepository);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: signInBloc,
        child: const SignInPage(),
      );
    }

    testWidgets('renders SignInLayoutBuilder with correct widgets',
        (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SignInLayoutBuilder), findsOneWidget);
      
      expect(find.byType(SignInHeader), findsOneWidget);
      expect(find.byType(SignInError), findsOneWidget);
      expect(find.byType(SignInEmailTextField), findsOneWidget);
      expect(find.byType(SignInPasswordTextField), findsOneWidget);
      expect(find.byType(SignInButton), findsOneWidget);
      expect(find.byType(SignInRedirection), findsOneWidget);
    });
  });
}
