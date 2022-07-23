// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInEvent', () {
    group('SignInEmailChanged', () {
      const email = 'email@example.com';

      test('supports value equality', () {
        expect(SignInEmailChanged(email), equals(SignInEmailChanged(email)));
      });

      test('props are correct', () {
        expect(SignInEmailChanged(email).props, equals(<Object?>[email]));
      });
    });

    group('SignInPasswordChanged', () {
      const password = 'password';

      test('supports value equality', () {
        expect(
          SignInPasswordChanged(password),
          equals(SignInPasswordChanged(password)),
        );
      });

      test('props are correct', () {
        expect(
          SignInPasswordChanged(password).props,
          equals(<Object?>[password]),
        );
      });
    });

    group('SignInPasswordVisibilityChanged', () {
      const passwordVisibility = true;

      test('supports value equality', () {
        expect(
          SignInPasswordVisibilityChanged(passwordVisibility),
          equals(SignInPasswordVisibilityChanged(passwordVisibility)),
        );
      });

      test('props are correct', () {
        expect(
          SignInPasswordVisibilityChanged(passwordVisibility).props,
          equals(<Object?>[passwordVisibility]),
        );
      });
    });

    group('SignInRequested', () {
      test('supports value equality', () {
        expect(SignInRequested(), equals(SignInRequested()));
      });

      test('props are correct', () {
        expect(SignInRequested().props, equals(<Object?>[]));
      });
    });
  });
}
