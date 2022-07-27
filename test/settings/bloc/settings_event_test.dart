// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';

class MockSettingsEvent extends SettingsEvent {}

void main() {
  group('SettingsEvent', () {
    group('BaseSettingsEvent', () {
      test('supports value equality', () {
        expect(MockSettingsEvent(), equals(MockSettingsEvent()));
      });

      test('props are correct', () {
        expect(MockSettingsEvent().props, equals(<Object?>[]));
      });
    });

    group('SettingsSelectedIndexChanged', () {
      const selectedIndex = 1;
      test('supports value equality', () {
        expect(
          SettingsSelectedIndexChanged(selectedIndex),
          equals(SettingsSelectedIndexChanged(selectedIndex)),
        );
      });

      test('props are correct', () {
        expect(
          SettingsSelectedIndexChanged(selectedIndex).props,
          equals(<Object?>[selectedIndex]),
        );
      });
    });
  });
}
