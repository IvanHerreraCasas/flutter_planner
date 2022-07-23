// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpEmailChanged', () {
      const email = 'email@example.com';

      test('supports value equality', () {
        expect(SignUpEmailChanged(email), equals(SignUpEmailChanged(email)));
      });

      test('props are correct', () {
        expect(SignUpEmailChanged(email).props, equals(<Object?>[email]));
      });
    });

    group('SignUpPasswordChanged', () {
      const password = 'password';

      test('supports value equality', () {
        expect(
          SignUpPasswordChanged(password),
          equals(SignUpPasswordChanged(password)),
        );
      });

      test('props are correct', () {
        expect(
          SignUpPasswordChanged(password).props,
          equals(<Object?>[password]),
        );
      });
    });

    group('SignUpPasswordVisibilityChanged', () {
      const passwordVisibility = true;

      test('supports value equality', () {
        expect(
          SignUpPasswordVisibilityChanged(passwordVisibility),
          equals(SignUpPasswordVisibilityChanged(passwordVisibility)),
        );
      });

      test('props are correct', () {
        expect(
          SignUpPasswordVisibilityChanged(passwordVisibility).props,
          equals(<Object?>[passwordVisibility]),
        );
      });
    });

    group('SignUpRequested', () {
      test('supports value equality', () {
        expect(SignUpRequested(), equals(SignUpRequested()));
      });

      test('props are correct', () {
        expect(SignUpRequested().props, equals(<Object?>[]));
      });
    });
  });
}
