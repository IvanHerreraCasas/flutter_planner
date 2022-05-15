import 'package:authentication_api/authentication_api.dart';
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
    late AuthenticationBloc authenticationBloc;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      when(() => authenticationRepository.status)
          .thenAnswer((_) => const Stream.empty());
      authenticationBloc = AuthenticationBloc(
        authenticationRepository: authenticationRepository,
      );
    });

    tearDown(() {
      authenticationBloc.close();
    });

    group('constructor', () {
      test(
          'works normally and '
          'starts listening to authenticationRepository.status', () {
        expect(() => authenticationBloc, returnsNormally);

        verify(() => authenticationRepository.status.listen((event) {}));
      });

      test('has correct initial state', () {
        expect(
          authenticationBloc.state,
          equals(const AuthenticationState.unknown()),
        );
      });
    });

    group('AuthenticationStatusChanged', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'emits unauthenticated when status is unauthenticated',
        build: () => authenticationBloc,
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
        build: () => authenticationBloc,
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
  });
}
