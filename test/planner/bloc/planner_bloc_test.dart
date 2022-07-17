import 'package:activities_api/activities_api.dart';
import 'package:activities_repository/activities_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

class MockActivitiesRepository extends Mock implements ActivitiesRepository {}

class MockRoutinesRepository extends Mock implements RoutinesRepository {}

void main() {
  group('PlannerBloc', () {
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;
    late TasksRepository tasksRepository;

    final date = DateTime.utc(2022, 5, 25);

    const mockUserID = 'userID';

    final mockActivities = [
      Activity(
        userID: 'userID',
        name: 'activity 1',
        date: date,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Activity(
        userID: 'userID',
        name: 'activity 2',
        date: date,
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
      ),
    ];

    final mockTasks = [
      Task(
        userID: 'userID',
        title: 'task 1',
        date: date,
        completed: true,
      ),
      Task(
        userID: 'userID',
        title: 'task 2',
        date: date,
        completed: false,
      ),
    ];

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();
      tasksRepository = MockTasksRepository();

      when(() => activitiesRepository.streamActivities(date: date)).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => tasksRepository.streamTasks(date: date)).thenAnswer(
        (_) => const Stream.empty(),
      );
      when(() => activitiesRepository.dispose())
          .thenAnswer((invocation) async {});
    });

    PlannerBloc buildBloc() {
      return PlannerBloc(
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
        tasksRepository: tasksRepository,
        userID: mockUserID,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(buildBloc().state, PlannerState());
      });
    });

    group('PlannerSubscriptionRequested', () {
      blocTest<PlannerBloc, PlannerState>(
        'starts listening to activitiesRepository streamActivities',
        setUp: () {
          when(() => activitiesRepository.streamActivities(date: date))
              .thenAnswer((_) => Stream.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerSubscriptionRequested()),
        verify: (bloc) {
          verify(() => activitiesRepository.streamActivities(date: date))
              .called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated activities '
        'when repository strem activities emits new activities',
        setUp: () {
          when(() => activitiesRepository.streamActivities(date: date))
              .thenAnswer((_) => Stream.value(mockActivities));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerSubscriptionRequested()),
        expect: () => <PlannerState>[
          PlannerState(
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          ),
        ],
      );
    });

    group('PlannerTasksSubRequested', () {
      blocTest<PlannerBloc, PlannerState>(
        'starts listening to tasksRepository streamTasks',
        setUp: () {
          when(() => tasksRepository.streamTasks(date: date))
              .thenAnswer((_) => Stream.value(mockTasks));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerTasksSubRequested()),
        verify: (bloc) {
          verify(() => tasksRepository.streamTasks(date: date)).called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated tasks '
        'when repository stream tasks emits new tasks',
        setUp: () {
          when(() => tasksRepository.streamTasks(date: date))
              .thenAnswer((_) => Stream.value(mockTasks));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerTasksSubRequested()),
        expect: () => <PlannerState>[
          PlannerState(
            selectedDay: date,
            focusedDay: date,
            tasks: mockTasks,
          ),
        ],
      );
    });

    group('PlannerSelectedDayChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated selectedDay',
        build: buildBloc,
        act: (bloc) => bloc.add(PlannerSelectedDayChanged(date)),
        expect: () => <PlannerState>[
          PlannerState(selectedDay: date),
        ],
      );
    });

    group('PlannerFocusedDayChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated focusedDay.',
        build: buildBloc,
        act: (bloc) => bloc.add(PlannerFocusedDayChanged(date)),
        expect: () => <PlannerState>[PlannerState(focusedDay: date)],
      );
    });

    group('PlannerNewTaskAdded', () {
      final newTask = Task.empty(userID: mockUserID);
      blocTest<PlannerBloc, PlannerState>(
        'attempts to save a new task',
        build: buildBloc,
        act: (bloc) => bloc.add(const PlannerNewTaskAdded()),
        expect: () => const <PlannerState>[],
        verify: (bloc) {
          verify(() => tasksRepository.saveTask(newTask)).called(1);
        },
      );
    });

    group('PlanerSelectedTabChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits new state with updated selectedTab',
        build: buildBloc,
        act: (bloc) => bloc.add(const PlannerSelectedTabChanged(1)),
        expect: () => <PlannerState>[
          PlannerState(selectedTab: 1),
        ],
      );
    });
  });
}
