// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInState', () {
    SignInState createSubject({
      SignInStatus status = SignInStatus.initial,
      String email = '',
      String password = '',
      bool passwordVisibility = false,
      String? errorMessage,
    }) {
      return SignInState(
        status: status,
        email: email,
        password: password,
        passwordVisibility: passwordVisibility,
        errorMessage: errorMessage,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object?>[
          SignInStatus.initial,
          '',
          '',
          false,
          null,
        ]),
      );
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter is null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            email: null,
            password: null,
            passwordVisibility: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            status: SignInStatus.failure,
            email: 'email@example.com',
            password: 'password',
            passwordVisibility: true,
            errorMessage: 'Error',
          ),
          equals(
            createSubject(
              status: SignInStatus.failure,
              email: 'email@example.com',
              password: 'password',
              passwordVisibility: true,
              errorMessage: 'Error',
            ),
          ),
        );
      });
    });
  });
}
