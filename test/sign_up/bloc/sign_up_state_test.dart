// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpState', () {
    SignUpState createSubject({
      SignUpStatus status = SignUpStatus.initial,
      String email = '',
      String password = '',
      bool passwordVisibility = false,
      String? errorMessage,
    }) {
      return SignUpState(
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
          SignUpStatus.initial,
          '',
          '',
          false,
          null,
        ]),
      );
    });

    group('copyWith', () {
      test('retains the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
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
            status: SignUpStatus.failure,
            email: 'email@example.com',
            password: 'password',
            passwordVisibility: true,
            errorMessage: 'error',
          ),
          equals(
            createSubject(
              status: SignUpStatus.failure,
              email: 'email@example.com',
              password: 'password',
              passwordVisibility: true,
              errorMessage: 'error',
            ),
          ),
        );
      });
    });
  });
}
