// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthenticationEvent', () {
    group('AuthenticationSubscriptionRequested', () {
      test('supports value equality', () {
        expect(
          AuthenticationSubscriptionRequested(),
          equals(AuthenticationSubscriptionRequested()),
        );
      });

      test('props are correct', () {
        expect(
          AuthenticationSubscriptionRequested().props,
          equals(<Object?>[]),
        );
      });
    });
    group('AuthenticationSignOutRequested', () {
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
