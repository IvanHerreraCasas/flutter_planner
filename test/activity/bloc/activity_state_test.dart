// ignore_for_file: avoid_redundant_argument_values

import 'package:activities_api/activities_api.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityState', () {
    final fakeDate = DateTime.utc(1970);
    final fakeStartTime = DateTime(1970, 1, 1, 7);
    final fakeEndTime = DateTime(1970, 1, 1, 8);

    final fakeInitialActivity = Activity(
      userID: 'user_id',
      name: 'name',
      description: 'description',
      date: fakeDate,
      startTime: fakeStartTime,
      endTime: fakeEndTime,
    );

    ActivityState createSubject({
      ActivityStatus status = ActivityStatus.initial,
      Activity? initialActivity,
      String name = 'name',
      int type = 0,
      String description = 'description',
      DateTime? date,
      DateTime? startTime,
      DateTime? endTime,
      List<String> links = const <String>[],
      String errorMessage = '',
      bool isAllDay = false,
      List<bool> reminderValues = const [],
    }) {
      return ActivityState(
        status: status,
        initialActivity: initialActivity ?? fakeInitialActivity,
        name: name,
        type: type,
        description: description,
        date: date ?? fakeDate,
        startTime: startTime ?? fakeStartTime,
        endTime: endTime ?? fakeEndTime,
        links: links,
        errorMessage: errorMessage,
        isAllDay: isAllDay,
        reminderValues: reminderValues,
      );
    }

    group('constructor', () {
      test('throws assertion error if date is not utc', () {
        expect(() => createSubject(date: DateTime(2022)), throwsAssertionError);
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
        equals(<Object?>[
          ActivityStatus.initial,
          fakeInitialActivity,
          'name',
          0,
          'description',
          fakeDate,
          fakeStartTime,
          fakeEndTime,
          <String>[],
          '',
          false,
          <bool>[],
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter is null is provided', () {
        expect(
          createSubject().copyWith(
            status: null,
            initialActivity: null,
            name: null,
            type: null,
            description: null,
            date: null,
            startTime: null,
            endTime: null,
            links: null,
            errorMessage: null,
            isAllDay: null,
            reminderValues: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null value', () {
        final altInitialActivity = Activity(
          userID: 'userID',
          date: DateTime.utc(2022),
          startTime: DateTime(2022, 1, 1, 10),
          endTime: DateTime(2022, 1, 1, 12),
        );

        final altDate = DateTime.utc(2022);
        final altStartTime = DateTime(2022, 1, 1, 10);
        final altEndTime = DateTime(2022, 1, 1, 12);

        expect(
          createSubject().copyWith(
            status: ActivityStatus.loading,
            initialActivity: altInitialActivity,
            name: 'Name',
            type: 1,
            description: '---',
            date: altDate,
            startTime: altStartTime,
            endTime: altEndTime,
            links: ['https://api.flutter.dev/'],
            errorMessage: 'error',
            isAllDay: true,
            reminderValues: [true, false, false, false],
          ),
          equals(
            createSubject(
              status: ActivityStatus.loading,
              initialActivity: altInitialActivity,
              name: 'Name',
              type: 1,
              description: '---',
              date: altDate,
              startTime: altStartTime,
              endTime: altEndTime,
              links: ['https://api.flutter.dev/'],
              errorMessage: 'error',
              isAllDay: true,
              reminderValues: [true, false, false, false],
            ),
          ),
        );
      });
    });
  });
}
