import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

void main() {
  const fakeUser = User(id: 'id');
  group('AuthenticationBloc', () {
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status)
          .thenAnswer((_) => const Stream.empty());
      when(() => authenticationRepository.signOut()).thenAnswer((_) async {});
    });

    AuthenticationBloc buildBloc() {
      return AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has unknown initial state, when user is null', () {
        expect(
          buildBloc().state,
          equals(const AuthenticationState.unknown()),
        );
      });

      test('has authenticated initial state, when user is not null', () {
        when(() => authenticationRepository.user).thenReturn(fakeUser);
        expect(
          buildBloc().state,
          equals(const AuthenticationState.authenticated(fakeUser)),
        );
      });
    });

    group('AuthenticationSubscriptionRequested', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'starts listening to authentication repository status.',
        setUp: () {
          when(() => authenticationRepository.status).thenAnswer(
            (_) => Stream.value(AuthenticationStatus.unauthenticated),
          );
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationSubscriptionRequested(),
        ),
        expect: () => const <AuthenticationState>[
          AuthenticationState.unauthenticated(),
        ],
        verify: (bloc) {
          verify(() => authenticationRepository.status).called(1);
        },
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits authenticated state when status is authenticated.',
        setUp: () {
          when(() => authenticationRepository.status).thenAnswer(
            (_) => Stream.value(AuthenticationStatus.authenticated),
          );
          when(() => authenticationRepository.user).thenReturn(fakeUser);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationSubscriptionRequested(),
        ),
        expect: () => const <AuthenticationState>[
          AuthenticationState.authenticated(fakeUser),
        ],
      );
    });

    group('AuthenticationSignOutRequested', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'attempts to signOut',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationSignoutRequested(),
        ),
        verify: (bloc) {
          verify(() => authenticationRepository.signOut()).called(1);
        },
      );
    });
  });
}
