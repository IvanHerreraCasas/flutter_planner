import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerTasksHeader', () {
    Widget buildSubject() {
      return const PlannerTasksHeader();
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
    });
  });
}
