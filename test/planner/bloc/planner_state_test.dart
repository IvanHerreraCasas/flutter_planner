// ignore_for_file: avoid_redundant_argument_values

import 'package:activities_api/activities_api.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_repository/tasks_repository.dart';

void main() {
  group('PlannerState', () {
    final currentDateTime = DateTime.now();

    final utcTodayDate = DateTime.utc(
      currentDateTime.year,
      currentDateTime.month,
      currentDateTime.day,
    );

    PlannerState createSubject({
      DateTime? selectedDay,
      DateTime? focusedDay,
      List<Activity> activities = const [],
      List<Task> tasks = const [],
    }) {
      return PlannerState(
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        activities: activities,
      );
    }

    group('constructor', () {
      test('if selectedDay is null, it takes the current utc date', () {
        expect(createSubject().selectedDay, equals(utcTodayDate));
      });

      test('if focusedDay is null, it takes the current utc date', () {
        expect(createSubject().focusedDay, equals(utcTodayDate));
      });
    });

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object?>[
          utcTodayDate,
          utcTodayDate,
          <Activity>[],
          <Task>[],
        ]),
      );
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(createSubject().copyWith(), equals(createSubject()));
      });

      test('retains the old value for every parameter if null is provided', () {
        expect(
          createSubject().copyWith(
            selectedDay: null,
            focusedDay: null,
            activities: null,
            tasks: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        final activity = Activity(
          userID: 'userID',
          date: DateTime(2022, 5, 22),
          startTime: DateTime(2022, 5, 22, 7, 0),
          endTime: DateTime(2022, 5, 22, 10, 0),
        );
        final task = Task.empty(userID: 'userID');
        expect(
          createSubject().copyWith(
            selectedDay: DateTime.utc(2022, 5, 22),
            focusedDay: DateTime.utc(2022, 5, 22),
            activities: [activity],
            tasks: [task],
          ).props,
          equals(<Object?>[
            DateTime.utc(2022, 5, 22),
            DateTime.utc(2022, 5, 22),
            [
              Activity(
                userID: 'userID',
                date: DateTime(2022, 5, 22),
                startTime: DateTime(2022, 5, 22, 7, 0),
                endTime: DateTime(2022, 5, 22, 10, 0),
              )
            ],
            [Task.empty(userID: 'userID')],
          ]),
        );
      });
    });
  });
}
