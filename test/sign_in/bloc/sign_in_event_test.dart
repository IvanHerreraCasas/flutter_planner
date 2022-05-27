// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/sign_in/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignInEvent', () {
    group('SignInEmailChanged', () {
      const email = 'email@example.com';
      final event = SignInEmailChanged(email);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[email]));
      });
    });

    group('SignInPasswordChanged', () {
      const password = 'password';
      final event = SignInPasswordChanged(password);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[password]));
      });
    });

    group('SignInPasswordVisibilityChanged', () {
      const passwordVisibility = true;
      final event = SignInPasswordVisibilityChanged(passwordVisibility);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[passwordVisibility]));
      });
    });

    group('SignInRequested', () {
      final event = SignInRequested();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
