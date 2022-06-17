// ignore_for_file: avoid_redundant_argument_values

import 'package:activities_api/activities_api.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ActivityState', () {
    final fakeDate = DateTime(1970);
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
      String description = 'description',
      DateTime? date,
      DateTime? startTime,
      DateTime? endTime,
      List<String> links = const <String>[],
    }) {
      return ActivityState(
        status: status,
        initialActivity: initialActivity ?? fakeInitialActivity,
        name: name,
        description: description,
        date: date ?? fakeDate,
        startTime: startTime ?? fakeStartTime,
        endTime: endTime ?? fakeEndTime,
        links: links,
      );
    }

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
          'description',
          fakeDate,
          fakeStartTime,
          fakeEndTime,
          <String>[],
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
            description: null,
            date: null,
            startTime: null,
            endTime: null,
            links: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null value', () {
        final altInitialActivity = Activity(
          userID: 'userID',
          date: DateTime(2022),
          startTime: DateTime(2022, 1, 1, 10),
          endTime: DateTime(2022, 1, 1, 12),
        );

        final altDate = DateTime(2022);
        final altStartTime = DateTime(2022, 1, 1, 10);
        final altEndTime = DateTime(2022, 1, 1, 12);

        expect(
          createSubject().copyWith(
            status: ActivityStatus.loading,
            initialActivity: altInitialActivity,
            name: 'Name',
            description: '---',
            date: altDate,
            startTime: altStartTime,
            endTime: altEndTime,
            links: ['https://api.flutter.dev/'],
          ),
          equals(
            createSubject(
              status: ActivityStatus.loading,
              initialActivity: altInitialActivity,
              name: 'Name',
              description: '---',
              date: altDate,
              startTime: altStartTime,
              endTime: altEndTime,
              links: ['https://api.flutter.dev/'],
            ),
          ),
        );
      });
    });
  });
}
