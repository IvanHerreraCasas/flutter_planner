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
        userID: mockUserID,
        name: 'activity 1',
        date: date,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Activity(
        userID: mockUserID,
        name: 'activity 2',
        date: date,
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
        routineID: 2,
      ),
    ];

    final mockTasks = [
      Task(
        userID: mockUserID,
        title: 'task 1',
        date: date,
        completed: true,
      ),
      Task(
        userID: mockUserID,
        title: 'task 2',
        date: date,
        completed: false,
      ),
    ];

    final mockRoutines = [
      Routine(
        id: 1,
        userID: mockUserID,
        name: '1',
        day: 1,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Routine(
        id: 2,
        userID: mockUserID,
        name: '2',
        day: date.weekday,
        startTime: DateTime(1970, 1, 1, 7),
        endTime: DateTime(1970, 1, 1, 9),
      ),
      Routine(
        id: 3,
        userID: mockUserID,
        name: '3',
        day: date.weekday,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Routine(
        id: 4,
        userID: mockUserID,
        name: '4',
        day: date.weekday,
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
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
      when(() => routinesRepository.fetchRoutines()).thenAnswer(
        (_) => Future.value(mockRoutines),
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

    group('PlannerAddRoutines', () {
      /// This test uses mockRoutines(4)
      /// The routine with id 1 has a different weekday,
      /// the one with id 2 has an existent activity,
      /// so only the routines with id: 3 and 4 must be added.

      final newActivities = [
        Activity(
          userID: mockRoutines[2].userID,
          name: mockRoutines[2].name,
          type: 2,
          date: date,
          startTime: mockRoutines[2].startTime,
          endTime: mockRoutines[2].endTime,
          routineID: mockRoutines[2].id,
        ),
        Activity(
          userID: mockRoutines[3].userID,
          name: mockRoutines[3].name,
          type: 2,
          date: date,
          startTime: mockRoutines[3].startTime,
          endTime: mockRoutines[3].endTime,
          routineID: mockRoutines[3].id,
        ),
      ];
      blocTest<PlannerBloc, PlannerState>(
        'attempts to create new activities '
        'from the routines that dont have a correspondent activity.',
        setUp: () {
          when(
            () => activitiesRepository.insertActivities(newActivities),
          ).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
          activities: mockActivities,
        ),
        act: (bloc) => bloc.add(const PlannerAddRoutines()),
        expect: () => [
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          ),
          PlannerState(
            status: PlannerStatus.success,
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          )
        ],
        verify: (bloc) {
          verify(
            () => activitiesRepository.insertActivities(newActivities),
          ).called(1);
        },
      );

      blocTest<PlannerBloc, PlannerState>(
        'emits state with failure status and errorMessage '
        'when activities repository insertActivities throws an error.',
        setUp: () {
          when(
            () => activitiesRepository.insertActivities(newActivities),
          ).thenThrow(Exception('error'));
        },
        build: buildBloc,
        seed: () => PlannerState(
          selectedDay: date,
          focusedDay: date,
          activities: mockActivities,
        ),
        act: (bloc) => bloc.add(const PlannerAddRoutines()),
        expect: () => [
          PlannerState(
            status: PlannerStatus.loading,
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
          ),
          PlannerState(
            status: PlannerStatus.failure,
            selectedDay: date,
            focusedDay: date,
            activities: mockActivities,
            errorMessage: 'error: routines could not be added',
          )
        ],
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
