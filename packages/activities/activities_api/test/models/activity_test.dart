// ignore_for_file: avoid_redundant_argument_values

import 'package:activities_api/activities_api.dart';
import 'package:test/test.dart';

void main() {
  group('Activity', () {
    Activity createSubject({
      int id = 1,
      String userID = 'user_id',
      String name = 'name',
      int type = 0,
      DateTime? date,
      DateTime? startTime,
      DateTime? endTime,
      String description = 'description',
      List<String> links = const [],
      int routineID = 0,
    }) {
      return Activity(
        id: id,
        userID: userID,
        name: name,
        type: type,
        date: date ?? DateTime.utc(2022, 04, 19),
        startTime: startTime ?? DateTime(1970, 01, 01, 17),
        endTime: endTime ?? DateTime(1970, 01, 01, 18),
        description: description,
        links: links,
        routineID: 0,
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

    test('isAllDay if start and time are 0', () {
      expect(
        createSubject(
          startTime: DateTime(1970),
          endTime: DateTime(1970),
        ).isAllDay,
        true,
      );
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals([
          1,
          'user_id',
          'name',
          0,
          DateTime.utc(2022, 04, 19),
          DateTime(1970, 01, 01, 17),
          DateTime(1970, 01, 01, 18),
          'description',
          <String>[],
          0
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
            id: null,
            name: null,
            type: null,
            date: null,
            startTime: null,
            endTime: null,
            description: null,
            links: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter, except for id and userID', () {
        expect(
          createSubject().copyWith(
            id: 2,
            name: 'check about layered architecture',
            type: 1,
            date: DateTime.utc(2022, 4, 20),
            startTime: DateTime(2022, 4, 20, 10),
            endTime: DateTime(2022, 4, 20, 12),
            description: '---',
            links: const [
              'https://verygood.ventures/blog/very-good-flutter-architecture'
            ],
            routineID: () => 1,
          ),
          equals(
            Activity(
              id: 2,
              userID: 'user_id',
              name: 'check about layered architecture',
              type: 1,
              date: DateTime.utc(2022, 4, 20),
              startTime: DateTime(2022, 4, 20, 10),
              endTime: DateTime(2022, 4, 20, 12),
              description: '---',
              links: const [
                'https://verygood.ventures/blog/very-good-flutter-architecture'
              ],
              routineID: 1,
            ),
          ),
        );
      });
    });

    test('fromJson works properly', () {
      expect(
        Activity.fromJson(
          const <String, dynamic>{
            'id': 1,
            'user_id': 'user_id',
            'name': 'name',
            'type': 0,
            'date': '2022-04-19',
            'start_time': '17:00:00',
            'end_time': '18:00:00',
            'description': 'description',
            'links': <String>[],
            'routine_id': 0
          },
        ),
        equals(createSubject()),
      );
    });

    test('toJson works properly', () {
      expect(
        createSubject().toJson(),
        equals(<String, dynamic>{
          'id': 1,
          'user_id': 'user_id',
          'name': 'name',
          'type': 0,
          'date': DateTime.utc(2022, 04, 19).toString(),
          'start_time': DateTime(1970, 01, 01, 17).toString(),
          'end_time': DateTime(1970, 01, 01, 18).toString(),
          'description': 'description',
          'links': const <String>[],
          'routine_id': 0
        }),
      );
    });
  });
}
