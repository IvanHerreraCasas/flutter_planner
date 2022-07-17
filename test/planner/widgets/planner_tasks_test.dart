import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';
import '../planner_mocks.dart';

void main() {
  group('PlannerTasks', () {
    late PlannerBloc plannerBloc;

    final mockTasks = [
      Task.empty(userID: 'userID'),
      Task.empty(userID: 'userID'),
    ];

    setUp(() {
      plannerBloc = MockPlannerBloc();

      when(() => plannerBloc.state).thenReturn(PlannerState(tasks: mockTasks));
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: plannerBloc,
        child: const PlannerTasks(),
      );
    }

    testWidgets('renders a ListView with Tasks', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TaskPage), findsNWidgets(mockTasks.length));
    });
  });
}
