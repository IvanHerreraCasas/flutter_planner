import 'package:activities_repository/activities_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

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
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.success,
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          ),
        ],
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with failure status and errorMessage '
        'when repository strem activities emits an error',
        setUp: () {
          when(() => activitiesRepository.streamActivities(date: date))
              .thenAnswer((_) => Stream.error('error'));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerSubscriptionRequested()),
        expect: () => <PlannerState>[
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.failure,
            selectedDay: date,
            focusedDay: date,
            errorMessage: 'error: activities could not be loaded',
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
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.success,
            selectedDay: date,
            focusedDay: date,
            tasks: mockTasks,
          ),
        ],
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with failure status and errorMessage '
        'when repository stream tasks emits error',
        setUp: () {
          when(() => tasksRepository.streamTasks(date: date))
              .thenAnswer((_) => Stream.error('error'));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerTasksSubRequested()),
        expect: () => <PlannerState>[
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.failure,
            selectedDay: date,
            focusedDay: date,
            errorMessage: 'error: tasks could not be loaded',
          ),
        ],
      );
    });

    group('PlannerSelectedDayChanged', () {
      blocTest<PlannerBloc, PlannerState>(
        'emits state with updated selectedDay '
        'and add tasks and activities subscription',
        build: buildBloc,
        act: (bloc) => bloc.add(PlannerSelectedDayChanged(date)),
        expect: () => <PlannerState>[
          PlannerState(
            selectedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
          ),
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
      final newTask = Task(
        userID: mockUserID,
        date: date,
        completed: false,
      );
      blocTest<PlannerBloc, PlannerState>(
        'attempts to save a new task',
        setUp: () {
          when(
            () => tasksRepository.saveTask(newTask),
          ).thenAnswer((_) => Future.value(newTask));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerNewTaskAdded()),
        expect: () => <PlannerState>[
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.success,
            selectedDay: date,
            focusedDay: date,
          ),
        ],
        verify: (bloc) {
          verify(() => tasksRepository.saveTask(newTask)).called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with failure status and errorMessage '
        'when taskRepository save task throws a exception',
        setUp: () {
          when(
            () => tasksRepository.saveTask(newTask),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
        ),
        act: (bloc) => bloc.add(const PlannerNewTaskAdded()),
        expect: () => <PlannerState>[
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
          ),
          PlannerState(
            status: PlannerStatus.failure,
            selectedDay: date,
            focusedDay: date,
            errorMessage: 'error: task could not be added',
          ),
        ],
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
