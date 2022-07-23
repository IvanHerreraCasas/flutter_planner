// ignore_for_file: prefer_const_constructors

import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskEvent', () {
    group('TaskSaved', () {
      test('supports value equality', () {
        expect(TaskSaved(), equals(TaskSaved()));
      });

      test('props are correct', () {
        expect(TaskSaved().props, equals(<Object?>[]));
      });
    });

    group('TaskDeleted', () {
      test('supports value equality', () {
        expect(TaskDeleted(), equals(TaskDeleted()));
      });

      test('props are correct', () {
        expect(TaskDeleted().props, equals(<Object?>[]));
      });
    });

    group('TaskTitleChanged', () {
      const title = 'title';

      test('supports value equality', () {
        expect(TaskTitleChanged(title), equals(TaskTitleChanged(title)));
      });

      test('props are correct', () {
        expect(TaskTitleChanged(title).props, equals(<Object?>[title]));
      });
    });

    group('TaskCompletetionToggled', () {
      test('supports value equality', () {
        expect(TaskCompletetionToggled(), equals(TaskCompletetionToggled()));
      });

      test('props are correct', () {
        expect(TaskCompletetionToggled().props, equals(<Object?>[]));
      });
    });
  });
}
