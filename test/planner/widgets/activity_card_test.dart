import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:reminders_repository/reminders_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ActivityCard', () {
    late GoRouter goRouter;
    late RemindersRepository remindersRepository;

    final mockActivity = Activity(
      userID: 'userID',
      name: 'name',
      description: 'description',
      date: DateTime.utc(2022, 6, 16),
      startTime: DateTime(1970, 1, 1, 17),
      endTime: DateTime(1970, 1, 1, 19),
    );

    setUp(() {
      goRouter = MockGoRouter();
      remindersRepository = MockRemindersRepository();

      when(() => remindersRepository.areAllowed).thenReturn(false);
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.large,
      Activity? activity,
      bool? isAllDay,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: ActivityCard(
          currentSize: currentSize,
          activity: activity ?? mockActivity,
          isAllDay: isAllDay ?? false,
        ),
      );
    }

    testWidgets(
        'renders the name and times '
        'when constraints.maxHeight is greater than 50 '
        'and is not allDay', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('name'), findsOneWidget);
      expect(find.text('17:00 - 19:00'), findsOneWidget);
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

    testWidgets(
        'renders only the name with 80px of height '
        'when isAllDay', (tester) async {
      await tester.pumpApp(buildSubject(isAllDay: true));

      expect(find.text('name'), findsOneWidget);
      expect(find.text('description'), findsNothing);

      expect(tester.getSize(find.byType(ActivityCard)).height, 80);
    });

    group('onTap', () {
      testWidgets(
          'shows ActivityPage dialog '
          'when size is large', (tester) async {
        await tester.pumpApp(
          buildSubject(),
          remindersRepository: remindersRepository,
        );

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
          remindersRepository: remindersRepository,
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
