import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TaskEvent', () {
    group('TaskSaved', () {
      const event = TaskSaved();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('TaskDeleted', () {
      const event = TaskDeleted();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });

    group('TaskTitleChanged', () {
      const title = 'title';
      const event = TaskTitleChanged(title);

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[title]));
      });
    });

    group('TaskCompletetionToggled', () {
      const event = TaskCompletetionToggled();

      test('supports value equality', () {
        expect(event, equals(event));
      });

      test('props are correct', () {
        expect(event.props, equals(<Object?>[]));
      });
    });
  });
}
