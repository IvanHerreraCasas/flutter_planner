import 'package:authentication_api/authentication_api.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAuthenticationApi extends Mock implements AuthenticationApi {}

void main() {
  group('AuthenticationRepository', () {
    late AuthenticationApi authenticationApi;

    const fakeEmail = 'email.example.com';
    const fakePassword = 'password';

    const fakeUser = User(id: 'id', email: fakeEmail);

    setUp(() {
      authenticationApi = MockAuthenticationApi();
      when(() => authenticationApi.user).thenAnswer((invocation) => fakeUser);
      when(() => authenticationApi.status).thenAnswer(
        (invocation) => Stream.value(AuthenticationStatus.authenticated),
      );
      when(
        () => authenticationApi.signUp(
          email: fakeEmail,
          password: fakePassword,
        ),
      ).thenAnswer((invocation) async {});
      when(
        () => authenticationApi.signIn(
          email: fakeEmail,
          password: fakePassword,
        ),
      ).thenAnswer(
        (invocation) async {},
      );
      when(() => authenticationApi.signOut())
          .thenAnswer((invocation) => Future.value());
    });

    AuthenticationRepository createSubject() =>
        AuthenticationRepository(authenticationApi: authenticationApi);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('getUser', () {
      test('makes correct api request', () {
        expect(createSubject().user, isNot(throwsA(anything)));

        verify(() => authenticationApi.user).called(1);
      });
    });

    group('getStatus', () {
      test('makes correct api request', () {
        expect(
          createSubject().status,
          emitsAnyOf(
            <AuthenticationStatus>[
              AuthenticationStatus.unauthenticated,
              AuthenticationStatus.authenticated,
            ],
          ),
        );
      });
    });

    group('signUp', () {
      test('makes correct api request', () {
        expect(
          createSubject().signUp(email: fakeEmail, password: fakePassword),
          completes,
        );

        verify(
          () => authenticationApi.signUp(
            email: fakeEmail,
            password: fakePassword,
          ),
        ).called(1);
      });
    });

    group('signIn', () {
      test('makes correct api request', () {
        expect(
          createSubject().signIn(email: fakeEmail, password: fakePassword),
          completes,
        );

        verify(
          () => authenticationApi.signIn(
            email: fakeEmail,
            password: fakePassword,
          ),
        ).called(1);
      });
    });

    group('signOut', () {
      test('makes correct api request', () async {
        expect(() async => createSubject().signOut(), returnsNormally);

        verify(() => authenticationApi.signOut()).called(1);
      });
    });
  });
}
