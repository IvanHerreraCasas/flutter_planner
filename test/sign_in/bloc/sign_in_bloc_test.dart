import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SignInBloc', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    SignInBloc buildBloc() {
      return SignInBloc(authenticationRepository: authenticationRepository);
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, equals(const SignInState()));
      });
    });

    group('SignInEmailChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits new state with updated email.',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignInEmailChanged('email@example.com')),
        expect: () => const <SignInState>[
          SignInState(email: 'email@example.com'),
        ],
      );
    });

    group('SignInPasswordChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits new state with updated password.',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignInPasswordChanged('password')),
        expect: () => const <SignInState>[
          SignInState(password: 'password'),
        ],
      );
    });

    group('SignInPasswordVisibilityChanged', () {
      blocTest<SignInBloc, SignInState>(
        'emits new state with updated passwordVisibility',
        build: buildBloc,
        act: (bloc) => bloc.add(const SignInPasswordVisibilityChanged(true)),
        expect: () => const <SignInState>[
          SignInState(passwordVisibility: true),
        ],
      );
    });

    group('SignInRequested', () {
      blocTest<SignInBloc, SignInState>(
        'attempts to signIn.',
        setUp: () {
          when(
            () => authenticationRepository.signIn(
              email: 'email@example.com',
              password: 'password',
            ),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => const SignInState(
          email: 'email@example.com',
          password: 'password',
        ),
        act: (bloc) => bloc.add(const SignInRequested()),
        expect: () => const <SignInState>[
          SignInState(
            status: SignInStatus.loading,
            email: 'email@example.com',
            password: 'password',
          ),
          SignInState(
            status: SignInStatus.success,
            email: 'email@example.com',
            password: 'password',
          ),
        ],
        verify: (bloc) {
          verify(
            () => authenticationRepository.signIn(
              email: 'email@example.com',
              password: 'password',
            ),
          );
        },
      );

      blocTest<SignInBloc, SignInState>(
        'emits new state with error if signIn fails.',
        setUp: () {
          when(
            () => authenticationRepository.signIn(
              email: 'email@example.com',
              password: 'password',
            ),
          ).thenThrow(Exception('oops'));
        },
        build: buildBloc,
        seed: () => const SignInState(
          email: 'email@example.com',
          password: 'password',
        ),
        act: (bloc) => bloc.add(const SignInRequested()),
        expect: () => const <SignInState>[
          SignInState(
            status: SignInStatus.loading,
            email: 'email@example.com',
            password: 'password',
          ),
          SignInState(
            status: SignInStatus.failure,
            email: 'email@example.com',
            password: 'password',
            errorMessage: 'Exception: oops',
          ),
        ],
      );
    });
  });
}
