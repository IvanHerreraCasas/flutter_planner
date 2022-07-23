import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TaskBloc', () {
    late TasksRepository tasksRepository;

    final mockInitialTask = Task.empty(userID: 'userID');
    final mockInitialState = TaskState(
      initialTask: mockInitialTask,
      title: mockInitialTask.title,
      isCompleted: mockInitialTask.completed,
    );

    setUp(() {
      tasksRepository = MockTasksRepository();
    });

    TaskBloc buildBloc() {
      return TaskBloc(
        tasksRepository: tasksRepository,
        initialTask: mockInitialTask,
      );
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildBloc, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(mockInitialState),
        );
      });
    });

    group('TaskTitleChanged', () {
      blocTest<TaskBloc, TaskState>(
        'emits new state with update title.',
        build: buildBloc,
        act: (bloc) => bloc.add(const TaskTitleChanged('new title')),
        expect: () => <TaskState>[
          mockInitialState.copyWith(title: 'new title'),
        ],
      );
    });

    group('TaskCompletetionToggled', () {
      blocTest<TaskBloc, TaskState>(
        'emits completed task state '
        'when tasks is not completed '
        'and attempts to save Task',
        setUp: () {
          when(
            () => tasksRepository.saveTask(
              mockInitialTask.copyWith(completed: true),
            ),
          ).thenAnswer((_) => Future.value(mockInitialTask));
        },
        build: buildBloc,
        seed: () => mockInitialState.copyWith(isCompleted: false),
        act: (bloc) => bloc.add(const TaskCompletetionToggled()),
        expect: () => <TaskState>[
          mockInitialState.copyWith(isCompleted: true),
          mockInitialState.copyWith(
            status: TaskStatus.loading,
            isCompleted: true,
          ),
          mockInitialState.copyWith(
            status: TaskStatus.success,
            isCompleted: true,
          ),
        ],
        verify: (bloc) {
          verify(
            () => tasksRepository.saveTask(
              mockInitialTask.copyWith(completed: true),
            ),
          );
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits not completed task state '
        'when tasks is completed '
        'and attempts to save Task',
        setUp: () {
          when(
            () => tasksRepository.saveTask(
              mockInitialTask.copyWith(completed: false),
            ),
          ).thenAnswer((_) => Future.value(mockInitialTask));
        },
        build: buildBloc,
        seed: () => mockInitialState.copyWith(isCompleted: true),
        act: (bloc) => bloc.add(const TaskCompletetionToggled()),
        expect: () => <TaskState>[
          mockInitialState.copyWith(isCompleted: false),
          mockInitialState.copyWith(
            status: TaskStatus.loading,
            isCompleted: false,
          ),
          mockInitialState.copyWith(
            status: TaskStatus.success,
            isCompleted: false,
          ),
        ],
      );
    });

    group('TaskSaved', () {
      final taskState = mockInitialState.copyWith(
        title: 'new title',
        isCompleted: true,
      );
      final newTask = mockInitialTask.copyWith(
        title: taskState.title,
        completed: taskState.isCompleted,
      );
      blocTest<TaskBloc, TaskState>(
        'attempts to save updated task',
        setUp: () {
          when(() => tasksRepository.saveTask(newTask))
              .thenAnswer((_) => Future.value(newTask));
        },
        build: buildBloc,
        seed: () => taskState,
        act: (bloc) => bloc.add(const TaskSaved()),
        expect: () => <TaskState>[
          taskState.copyWith(status: TaskStatus.loading),
          taskState.copyWith(
            status: TaskStatus.success,
            initialTask: newTask,
          ),
        ],
        verify: (bloc) {
          verify(() => tasksRepository.saveTask(newTask)).called(1);
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits new state with error if save task fails.',
        setUp: () {
          when(() => tasksRepository.saveTask(newTask))
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        seed: () => taskState,
        act: (bloc) => bloc.add(const TaskSaved()),
        expect: () => <TaskState>[
          taskState.copyWith(status: TaskStatus.loading),
          taskState.copyWith(status: TaskStatus.failure),
        ],
      );
    });

    group('TaskDeleted', () {
      blocTest<TaskBloc, TaskState>(
        'not attempt to delete task if initial task id is null.',
        build: buildBloc,
        act: (bloc) => bloc.add(const TaskDeleted()),
        expect: () => const <TaskState>[],
        verify: (bloc) {
          verifyNever(() => tasksRepository.deleteTask(any()));
        },
      );

      final task = Task(
        id: 1,
        userID: 'userID',
        date: DateTime.utc(2022),
        title: 'title',
        completed: true,
      );

      final taskState = TaskState(initialTask: task);

      blocTest<TaskBloc, TaskState>(
        'attempts to delete task if initial task id is non-null.',
        setUp: () {
          when(() => tasksRepository.deleteTask(1)).thenAnswer((_) async {});
        },
        build: buildBloc,
        seed: () => taskState,
        act: (bloc) => bloc.add(const TaskDeleted()),
        expect: () => <TaskState>[
          taskState.copyWith(status: TaskStatus.loading),
          taskState.copyWith(status: TaskStatus.success),
        ],
        verify: (bloc) {
          verify(() => tasksRepository.deleteTask(1));
        },
      );

      blocTest<TaskBloc, TaskState>(
        'emits new state with error if delete task fails.',
        setUp: () {
          when(() => tasksRepository.deleteTask(1))
              .thenThrow(Exception('error'));
        },
        build: buildBloc,
        seed: () => taskState,
        act: (bloc) => bloc.add(const TaskDeleted()),
        expect: () => <TaskState>[
          taskState.copyWith(status: TaskStatus.loading),
          taskState.copyWith(status: TaskStatus.failure),
        ],
      );
    });
  });
}
