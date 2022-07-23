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
      test(
          'works normally and '
          'starts listening to authenticationRepository.status', () {
        expect(buildBloc, returnsNormally);

        verify(() => authenticationRepository.status.listen((event) {}));
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

    group('AuthenticationStatusChanged', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits unauthenticated when status is unauthenticated',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationStatusChanged(
            AuthenticationStatus.unauthenticated,
          ),
        ),
        expect: () => const <AuthenticationState>[
          AuthenticationState.unauthenticated(),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits authenticated when status is authenticated',
        setUp: () {
          when(() => authenticationRepository.user).thenAnswer((_) => fakeUser);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationStatusChanged(
            AuthenticationStatus.authenticated,
          ),
        ),
        expect: () => const <AuthenticationState>[
          AuthenticationState.authenticated(fakeUser),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits authenticated when status is authenticated',
        setUp: () {
          when(() => authenticationRepository.user).thenAnswer((_) => fakeUser);
        },
        build: buildBloc,
        act: (bloc) => bloc.add(
          const AuthenticationStatusChanged(
            AuthenticationStatus.authenticated,
          ),
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
          AuthenticationSignoutRequested(),
        ),
        verify: (bloc) {
          verify(() => authenticationRepository.signOut()).called(1);
        },
      );
    });
  });
}
