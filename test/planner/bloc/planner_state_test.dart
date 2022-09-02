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
      PlannerStatus status = PlannerStatus.initial,
      DateTime? selectedDay,
      DateTime? focusedDay,
      List<Activity> activities = const [],
      List<Activity> events = const [],
      List<Task> tasks = const [],
      int selectedTab = 0,
      String errorMessage = '',
    }) {
      return PlannerState(
        status: status,
        selectedDay: selectedDay,
        focusedDay: focusedDay,
        activities: activities,
        events: events,
        selectedTab: 0,
        errorMessage: errorMessage,
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
          PlannerStatus.initial,
          utcTodayDate,
          utcTodayDate,
          <Activity>[],
          <Activity>[],
          <Task>[],
          0,
          '',
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
            status: null,
            selectedDay: null,
            focusedDay: null,
            activities: null,
            events: null,
            tasks: null,
            selectedTab: null,
            errorMessage: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null parameter', () {
        final activity = Activity(
          userID: 'userID',
          type: 1,
          date: DateTime.utc(2022, 5, 22),
          startTime: DateTime(2022, 5, 22, 7, 0),
          endTime: DateTime(2022, 5, 22, 10, 0),
        );
        final task = Task.empty(userID: 'userID');
        expect(
          createSubject()
              .copyWith(
                status: PlannerStatus.failure,
                selectedDay: DateTime.utc(2022, 5, 22),
                focusedDay: DateTime.utc(2022, 5, 22),
                activities: [activity],
                events: [activity],
                tasks: [task],
                selectedTab: 1,
                errorMessage: 'error',
              )
              .props,
          equals(<Object?>[
            PlannerStatus.failure,
            DateTime.utc(2022, 5, 22),
            DateTime.utc(2022, 5, 22),
            [
              Activity(
                userID: 'userID',
                type: 1,
                date: DateTime.utc(2022, 5, 22),
                startTime: DateTime(2022, 5, 22, 7, 0),
                endTime: DateTime(2022, 5, 22, 10, 0),
              )
            ],
            [
              Activity(
                userID: 'userID',
                type: 1,
                date: DateTime.utc(2022, 5, 22),
                startTime: DateTime(2022, 5, 22, 7, 0),
                endTime: DateTime(2022, 5, 22, 10, 0),
              )
            ],
            [Task.empty(userID: 'userID')],
            1,
            'error',
          ]),
        );
      });
    });
  });
}
