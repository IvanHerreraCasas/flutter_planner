// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AuthenticationStatusChanged', () {
      const status = AuthenticationStatus.authenticated;
      test('supports value equality', () {
        expect(
          AuthenticationStatusChanged(status),
          equals(AuthenticationStatusChanged(status)),
        );
      });

      test('props are correct', () {
        expect(
          AuthenticationStatusChanged(status).props,
          equals(<Object?>[status]),
        );
      });
    });

    group('AuthenticationStatusChanged', () {
      test('supports value equality', () {
        expect(
          AuthenticationSignoutRequested(),
          equals(AuthenticationSignoutRequested()),
        );
      });

      test('props are correct', () {
        expect(AuthenticationSignoutRequested().props, equals(<Object?>[]));
      });
    });
  });
}
