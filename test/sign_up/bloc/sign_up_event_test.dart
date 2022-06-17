// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/sign_up/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SignUpEvent', () {
    group('SignUpEmailChanged', () {
      const email = 'email@example.com';
      final event = SignUpEmailChanged(email);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[email]));
      });
    });

    group('SignUpPasswordChanged', () {
      const password = 'password';
      final event = SignUpPasswordChanged(password);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[password]));
      });
    });

    group('SignUpPasswordVisibilityChanged', () {
      const passwordVisibility = true;
      final event = SignUpPasswordVisibilityChanged(passwordVisibility);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[passwordVisibility]));
      });
    });

    group('SignUpRequested', () {
      final event = SignUpRequested();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
