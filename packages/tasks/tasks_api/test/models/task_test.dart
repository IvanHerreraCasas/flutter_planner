// ignore_for_file: avoid_redundant_argument_values

import 'package:tasks_api/tasks_api.dart';
import 'package:test/test.dart';

void main() {
  group('Task', () {
    final mockDate = DateTime.utc(2022, 07, 15);

    Task createSubject({
      int id = 1,
      String userID = 'userID',
      String title = 'title',
      DateTime? date,
      bool completed = false,
    }) {
      return Task(
        id: id,
        userID: userID,
        title: title,
        date: date ?? mockDate,
        completed: completed,
      );
    }

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });

      test('throws assertion error if date is not utc', () {
        expect(
          () => createSubject(date: DateTime(2022, 04, 19)),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error if date has time', () {
        expect(
          () => createSubject(date: DateTime(2022, 04, 19, 1)),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object>[
          1,
          'userID',
          'title',
          mockDate,
          false,
        ]),
      );
    });

    group('copyWith', () {
      test('return the same object if no arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            title: null,
            date: null,
            completed: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter, except for id and userID', () {
        expect(
          createSubject().copyWith(
            title: 'new title',
            date: DateTime.utc(2023),
            completed: true,
          ),
          equals(
            createSubject(
              title: 'new title',
              date: DateTime.utc(2023),
              completed: true,
            ),
          ),
        );
      });
    });

    test('fromJson works properly', () {
      expect(
        Task.fromJson(<String, dynamic>{
          'id': 1,
          'user_id': 'userID',
          'title': 'title',
          'date': mockDate.toString(),
          'completed': false,
        }),
        equals(createSubject()),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject().toJson(),
        equals(<String, dynamic>{
          'id': 1,
          'user_id': 'userID',
          'title': 'title',
          'date': mockDate.toString(),
          'completed': false,
        }),
      );
    });
  });
}
