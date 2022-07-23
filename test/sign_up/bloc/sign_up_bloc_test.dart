import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignUpBloc', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    SignUpBloc buildBloc() {
      return SignUpBloc(
        authenticationRepository: authenticationRepository,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(const SignUpState()));
      });
    });

    group('SignUpEmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits new state with updated email.',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const SignUpEmailChanged('email@example.com'),
        ),
        expect: () => const <SignUpState>[
          SignUpState(email: 'email@example.com'),
        ],
      );
    });

    group('SignUpPasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits new state with updated password.',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const SignUpPasswordChanged('password'),
        ),
        expect: () => const <SignUpState>[
          SignUpState(password: 'password'),
        ],
      );
    });

    group('SignUpPasswordVisibilityChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits new state with updated passwordVisibility.',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const SignUpPasswordVisibilityChanged(true),
        ),
        expect: () => const <SignUpState>[
          SignUpState(passwordVisibility: true),
        ],
      );
    });

    group('SignUpRequested', () {
      const email = 'email@example.com';
      const password = 'password';
      blocTest<SignUpBloc, SignUpState>(
        'attempts to signUp.',
        setUp: () {
          when(
            () => authenticationRepository.signUp(
              email: email,
              password: password,
            ),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => const SignUpState(email: email, password: password),
        act: (bloc) => bloc.add(const SignUpRequested()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: SignUpStatus.loading,
            email: email,
            password: password,
          ),
          SignUpState(
            status: SignUpStatus.success,
            email: email,
            password: password,
          ),
        ],
        verify: (bloc) {
          verify(
            () => authenticationRepository.signUp(
              email: email,
              password: password,
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits new state with error if signUp fails.',
        setUp: () {
          when(
            () => authenticationRepository.signUp(
              email: email,
              password: password,
            ),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        seed: () => const SignUpState(
          email: email,
          password: password,
        ),
        act: (bloc) => bloc.add(const SignUpRequested()),
        expect: () => const <SignUpState>[
          SignUpState(
            status: SignUpStatus.loading,
            email: email,
            password: password,
          ),
          SignUpState(
            status: SignUpStatus.failure,
            email: email,
            password: password,
            errorMessage: 'Exception: error',
          ),
        ],
      );
    });
  });
}
