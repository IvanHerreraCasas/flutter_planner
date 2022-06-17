// ignore_for_file: prefer_const_constructors

import 'package:authentication_api/authentication_api.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AuthenticationStatusChanged', () {
      const status = AuthenticationStatus.authenticated;
      final event = AuthenticationStatusChanged(status);
      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[status]));
      });
    });

    group('AuthenticationStatusChanged', () {
      final event = AuthenticationSignoutRequested();
      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
