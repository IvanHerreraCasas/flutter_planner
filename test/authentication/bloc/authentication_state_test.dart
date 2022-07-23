// ignore_for_file: prefer_const_constructors

import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUser extends Mock implements User {}

void main() {
  group('AuthenticationState', () {
    group('AuthenticationState.unknown', () {
      final state = AuthenticationState.unknown();
      test('supports value equality', () {
        expect(
          state,
          equals(state),
        );
      });

      test('props are correct', () {
        expect(
          state.props,
          equals(<Object?>[AuthenticationStatus.unknown, null]),
        );
      });
    });

    group('AuthenticationState.unauthenticated', () {
      final state = AuthenticationState.unauthenticated();
      test('supports value equality', () {
        expect(state, equals(state));
      });

      test('props are correct', () {
        expect(
          state.props,
          equals(<Object?>[AuthenticationStatus.unauthenticated, null]),
        );
      });
    });

    group('AuthenticationState.authenticated', () {
      final user = MockUser();
      final state = AuthenticationState.authenticated(user);
      test('supports value equality', () {
        expect(state, equals(state));
      });

      test('props are correct', () {
        expect(
          state.props,
          equals(<Object?>[AuthenticationStatus.authenticated, user]),
        );
      });
    });
  });
}
