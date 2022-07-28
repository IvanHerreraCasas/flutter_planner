import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('MyDetailsBloc', () {
    late AuthenticationRepository authenticationRepository;

    const mockUser = User(
      id: 'id',
      name: 'name',
      email: 'email@example.com',
    );

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
    });

    MyDetailsBloc buildBloc() {
      return MyDetailsBloc(
        user: mockUser,
        authenticationRepository: authenticationRepository,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(
            const MyDetailsState(
              userName: 'name',
              email: 'email@example.com',
            ),
          ),
        );
      });
    });

    group('UserNameChanged', () {
      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits new state with updated userName.',
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsUserNameChanged('userName')),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            userName: 'userName',
            email: 'email@example.com',
          ),
        ],
      );
    });

    group('EmailChanged', () {
      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits new state with updated email',
        build: buildBloc,
        act: (bloc) => bloc.add(
          const MyDetailsEmailChanged('new-email@example.com'),
        ),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            userName: 'name',
            email: 'new-email@example.com',
          ),
        ],
      );
    });

    group('UserNameSaved', () {
      blocTest<MyDetailsBloc, MyDetailsState>(
        'attempts to changeName in authenticationRepository.',
        setUp: () {
          when(
            () => authenticationRepository.changeName(name: 'name'),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsUserNameSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.success,
            userName: 'name',
            email: 'email@example.com',
          ),
        ],
        verify: (bloc) {
          verify(
            () => authenticationRepository.changeName(name: 'name'),
          ).called(1);
        },
      );

      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits state with failure status and errorMessage '
        'when authenticationRepository changeName throws a exception',
        setUp: () {
          when(
            () => authenticationRepository.changeName(name: 'name'),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsUserNameSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.failure,
            userName: 'name',
            email: 'email@example.com',
            errorMessage: 'error: the name could not be changed',
          ),
        ],
      );
    });

    group('EmailSaved', () {
      blocTest<MyDetailsBloc, MyDetailsState>(
        'attempts to changeEmail in authenticationRepository.',
        setUp: () {
          when(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsEmailSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.success,
            userName: 'name',
            email: 'email@example.com',
          ),
        ],
        verify: (bloc) {
          verify(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).called(1);
        },
      );

      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits state with failure status and errorMessage '
        'when authenticationRepository changeEmail throws a exception',
        setUp: () {
          when(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsEmailSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.failure,
            userName: 'name',
            email: 'email@example.com',
            errorMessage: 'error: the email could not be changed',
          ),
        ],
      );
    });

    group('Saved', () {
      blocTest<MyDetailsBloc, MyDetailsState>(
        'attempts to change userName and email in authenticationRepository.',
        setUp: () {
          when(
            () => authenticationRepository.changeName(name: 'name'),
          ).thenAnswer((_) async {});
          when(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.success,
            userName: 'name',
            email: 'email@example.com',
          ),
        ],
        verify: (bloc) {
          verify(
            () => authenticationRepository.changeName(name: 'name'),
          ).called(1);
          verify(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).called(1);
        },
      );

      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits state with failure status and errorMessage '
        'when authenticationRepository changeName throws a exception.',
        setUp: () {
          when(
            () => authenticationRepository.changeName(name: 'name'),
          ).thenThrow(Exception('error'));
          when(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.failure,
            userName: 'name',
            email: 'email@example.com',
            errorMessage: 'error: details could not be changed',
          ),
        ],
      );

      blocTest<MyDetailsBloc, MyDetailsState>(
        'emits state with failure status and errorMessage '
        'when authenticationRepository changeEmail throws a exception.',
        setUp: () {
          when(
            () => authenticationRepository.changeName(name: 'name'),
          ).thenAnswer((_) async {});
          when(
            () => authenticationRepository.changeEmail(
              email: 'email@example.com',
            ),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const MyDetailsSaved()),
        expect: () => const <MyDetailsState>[
          MyDetailsState(
            status: MyDetailsStatus.loading,
            userName: 'name',
            email: 'email@example.com',
          ),
          MyDetailsState(
            status: MyDetailsStatus.failure,
            userName: 'name',
            email: 'email@example.com',
            errorMessage: 'error: details could not be changed',
          ),
        ],
      );
    });
  });
}
