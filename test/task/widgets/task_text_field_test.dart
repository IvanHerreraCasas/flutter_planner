import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../task_mocks.dart';

void main() {
  group('TaskTextField', () {
    late TaskBloc taskBloc;
    late PlannerBloc plannerBloc;

    setUp(() {
      taskBloc = MockTaskBloc();
      plannerBloc = MockPlannerBloc();

      when(() => taskBloc.state).thenReturn(
        TaskState(initialTask: mockTask),
      );
    });

    Widget buildSubject({
      String initialTitle = '',
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: taskBloc),
          BlocProvider.value(value: plannerBloc),
        ],
        child: TaskTextField(initialTitle: initialTitle),
      );
    }

    testWidgets('renders a TextField', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets(
        'add TaskTitleChanged '
        'to TaskBloc when new value is entered', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.enterText(find.byType(TextField), 'new title');

      verify(
        () => taskBloc.add(const TaskTitleChanged('new title')),
      ).called(1);
    });

    group('onEditingComplete', () {
      testWidgets(
          'add PlannerNewTaskAdded '
          'to PlannerBloc when title is not empty', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.enterText(find.byType(TextField), 'new title');

        tester.testTextInput.closeConnection();

        verify(
          () => plannerBloc.add(const PlannerNewTaskAdded()),
        ).called(1);
      });

      testWidgets('unfocus when title is empty', (tester) async {
        await tester.pumpApp(buildSubject(initialTitle: 'title'));

        await tester.enterText(find.byType(TextField), '');

        tester.testTextInput.closeConnection();

        await tester.pump();

        final focusNode =
            (tester.widget(find.byType(TextField)) as TextField).focusNode;

        expect(focusNode?.hasFocus, false);
      });
    });
  });
}
