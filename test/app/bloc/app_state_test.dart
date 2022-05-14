// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppState', () {
    AppState createSubject({
      String route = '/sign-in',
    }) {
      return AppState(route: route);
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(['/sign-in']));
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(createSubject().copyWith(route: null), equals(createSubject()));
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(route: '/home'),
          equals(createSubject(route: '/home')),
        );
      });
    });

    test('fromJson works properly', () {
      expect(
        AppState.fromJson(const <String, dynamic>{'route': '/home'}),
        equals(createSubject(route: '/home')),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject().toJson(),
        equals(<String, dynamic>{'route': '/sign-in'}),
      );
    });
  });
}
