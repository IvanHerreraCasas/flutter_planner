// ignore_for_file: prefer_const_constructors
import 'package:mocktail/mocktail.dart';
import 'package:tasks_api/tasks_api.dart';
import 'package:tasks_repository/tasks_repository.dart';
import 'package:test/test.dart';

class MockTaskApi extends Mock implements TasksApi {}

void main() {
  group('TasksRepository', () {
    late TasksApi tasksApi;
    final mockDate = DateTime.utc(2022, 7, 15);

    final mockTask = Task.empty(userID: 'userID');

    final mockTasks = [
      Task(
        id: 1,
        userID: 'userID',
        title: 'task 1',
        date: mockDate,
        completed: true,
      ),
      Task(
        id: 2,
        userID: 'userID',
        title: 'task 2',
        date: mockDate,
        completed: false,
      ),
      Task(
        id: 3,
        userID: 'userID',
        title: 'task 3',
        date: mockDate,
        completed: true,
      ),
    ];

    setUp(() {
      tasksApi = MockTaskApi();

      when(() => tasksApi.streamTasks(date: mockDate)).thenAnswer(
        (_) => Stream.value(mockTasks),
      );
      when(() => tasksApi.saveTask(mockTask)).thenAnswer(
        (_) => Future.value(mockTask),
      );
      when(() => tasksApi.deleteTask(1)).thenAnswer((_) async {});
    });

    TasksRepository createSubject() => TasksRepository(tasksApi: tasksApi);

    group('constructor', () {
      test('works properly', () {
        expect(createSubject, returnsNormally);
      });
    });

    group('streamTasks', () {
      test('makes correct api request', () {
        expect(
          createSubject().streamTasks(date: mockDate),
          isNot(throwsA(anything)),
        );

        verify(() => tasksApi.streamTasks(date: mockDate)).called(1);
      });

      test(
          'makes only one request '
          'when is called multiple time for the same date', () async {
        final tasksRepository = createSubject()..streamTasks(date: mockDate);
        await Future<void>.delayed(const Duration(milliseconds: 100));
        tasksRepository.streamTasks(date: mockDate);

        verify(() => tasksApi.streamTasks(date: mockDate)).called(1);
      });

      test('return stream of current list of tasks', () {
        expect(
          createSubject().streamTasks(date: mockDate),
          emits(mockTasks),
        );
      });
    });

    group('saveTask', () {
      test('makes correct api request', () {
        expect(createSubject().saveTask(mockTask), completes);

        verify(() => tasksApi.saveTask(mockTask)).called(1);
      });

      test('returns the saved task', () async {
        expect(await createSubject().saveTask(mockTask), equals(mockTask));
      });
    });

    group('deleteTask', () {
      test('makes correct api request', () {
        expect(createSubject().deleteTask(1), completes);

        verify(() => tasksApi.deleteTask(1)).called(1);
      });
    });
  });
}
