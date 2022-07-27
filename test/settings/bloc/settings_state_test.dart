// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SettingsState', () {
    SettingsState createSubject({int selectedIndex = 0}) {
      return SettingsState(selectedIndex: selectedIndex);
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(<Object?>[0]));
    });

    group('copyWith', () {
      test('returns the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(selectedIndex: null),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(selectedIndex: 1),
          equals(createSubject(selectedIndex: 1)),
        );
      });
    });
  });
}
