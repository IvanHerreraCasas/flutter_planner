import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:tasks_repository/tasks_repository.dart';

class MockTaskBloc extends MockBloc<TaskEvent, TaskState> implements TaskBloc {}

final mockTask = Task(
  userID: 'userID',
  title: 'title',
  date: DateTime(2022),
  completed: true,
);
