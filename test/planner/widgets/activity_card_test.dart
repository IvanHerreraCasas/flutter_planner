import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ActivityCard', () {
    late GoRouter goRouter;
    final mockActivity = Activity(
      userID: 'userID',
      name: 'name',
      description: 'description',
      date: DateTime.utc(2022, 6, 16),
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 9),
    );

    setUp(() {
      goRouter = MockGoRouter();
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.large,
      double width = 400,
      Activity? activity,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: ActivityCard(
          currentSize: currentSize,
          activity: activity ?? mockActivity,
        ),
      );
    }

    testWidgets(
        'renders the name and times '
        'when constraints.maxHeight is greater than 50', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('name'), findsOneWidget);
      expect(find.text('07:00 - 09:00'), findsOneWidget);
    });

    testWidgets(
        'renders only the name '
        'when constraints.maxHeight is not greater than 50', (tester) async {
      await tester.pumpApp(
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 40),
          child: buildSubject(),
        ),
      );

      expect(find.text('name'), findsOneWidget);
      expect(find.text('description'), findsNothing);
    });

    group('onTap', () {
      testWidgets(
          'shows ActivityPage dialog '
          'when size is large', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('name'));

        await tester.pump();

        final activityPage = tester.widget<ActivityPage>(
          find.byType(ActivityPage),
        );

        expect(activityPage.isDialog, equals(true));
      });

      testWidgets('goes to activityPage', (tester) async {
        await tester.pumpApp(
          buildSubject(currentSize: PlannerSize.small),
        );

        await tester.tap(find.text('name'));

        verify(
          () => goRouter.goNamed(
            AppRoutes.activity,
            params: {'page': 'planner'},
            extra: mockActivity,
          ),
        ).called(1);
      });
    });
  });
}
