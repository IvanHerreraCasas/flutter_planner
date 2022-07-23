import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerTasksHeader', () {
    late PlannerBloc plannerBloc;

    setUp(() {
      plannerBloc = MockPlannerBloc();
    });
    Widget buildSubject() {
      return BlocProvider.value(
        value: plannerBloc,
        child: const PlannerTasksHeader(),
      );
    }

    testWidgets('renders Tasks Title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Tasks'), findsOneWidget);
    });

    group('ElevatedButton: + new', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, '+ new'),
          findsOneWidget,
        );
      });

      testWidgets(
          'add PlannerNewTaskAdded to PlannerBloc '
          'when is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(ElevatedButton, '+ new'));

        verify(() => plannerBloc.add(const PlannerNewTaskAdded()));
      });
    });
  });
}
