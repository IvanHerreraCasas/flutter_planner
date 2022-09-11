// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemindersState', () {
    RemindersState createSubject({
      List<bool> reminderValues = const [],
    }) {
      return RemindersState(
        reminderValues: reminderValues,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(createSubject().props, equals(<Object?>[const <bool>[]]));
    });

    group('copyWith', () {
      test('return the same object if no argument are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            reminderValues: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        expect(
          createSubject().copyWith(
            reminderValues: [true, false],
          ),
          equals(createSubject(reminderValues: [true, false])),
        );
      });
    });
  });
}
