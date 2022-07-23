import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../task_mocks.dart';

void main() {
  group('TaskCheckBox', () {
    late TaskBloc taskBloc;

    setUp(() {
      taskBloc = MockTaskBloc();

      when(() => taskBloc.state).thenReturn(
        TaskState(initialTask: mockTask),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: taskBloc,
        child: const TaskCheckBox(),
      );
    }

    testWidgets('renders CheckBox', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(Checkbox), findsOneWidget);
    });

    testWidgets(
        'add TaskCompletetionToggled '
        'to TaskBloc when is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(Checkbox));

      verify(
        () => taskBloc.add(const TaskCompletetionToggled()),
      ).called(1);
    });
  });
}
