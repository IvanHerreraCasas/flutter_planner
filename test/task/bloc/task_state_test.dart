// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tasks_repository/tasks_repository.dart';

void main() {
  group('TaskState', () {
    final mockInitialTask = Task.empty(userID: 'userID');

    TaskState createSubject({
      TaskStatus status = TaskStatus.initial,
      Task? initialTask,
      String title = 'title',
      bool completed = false,
    }) {
      return TaskState(
        status: status,
        initialTask: initialTask ?? mockInitialTask,
        title: title,
        isCompleted: completed,
      );
    }

    test('supports value equality', () {
      expect(createSubject(), equals(createSubject()));
    });

    test('props are correct', () {
      expect(
        createSubject().props,
        equals(<Object?>[
          TaskStatus.initial,
          mockInitialTask,
          'title',
          false,
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
            initialTask: null,
            title: null,
            isCompleted: null,
          ),
          equals(createSubject()),
        );
      });

      test('replaces every non-null value', () {
        final task = Task(
          id: 1,
          userID: 'userID',
          date: DateTime.utc(2022, 7, 16),
          title: 'task 1',
          completed: false,
        );
        expect(
          createSubject().copyWith(
            status: TaskStatus.success,
            initialTask: task,
            title: 'task 1',
            isCompleted: true,
          ),
          equals(
            createSubject(
              status: TaskStatus.success,
              initialTask: task,
              title: 'task 1',
              completed: true,
            ),
          ),
        );
      });
    });
  });
}
