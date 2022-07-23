import 'package:activities_repository/activities_repository.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../planner_mocks.dart';

void main() {
  group('PlannerActivitiesHeader', () {
    late GoRouter goRouter;
    late PlannerBloc plannerBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      goRouter = MockGoRouter();
      plannerBloc = MockPlannerBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.large,
    }) {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: plannerBloc),
            BlocProvider.value(value: authenticationBloc),
          ],
          child: PlannerActivitiesHeader(
            currentSize: currentSize,
          ),
        ),
      );
    }

    testWidgets('renders planner title', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Activities'), findsOneWidget);
    });

    group('ElevatedButton: Add Routines', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, 'Add routines'),
          findsOneWidget,
        );
      });

      testWidgets(
          'add PlannerAddRoutines '
          'to PlannerBloc '
          'when is tapped', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(ElevatedButton, 'Add routines'));

        verify(() => plannerBloc.add(const PlannerAddRoutines())).called(1);
      });
    });

    group('ElevatedButton: Add', () {
      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, 'Add'),
          findsOneWidget,
        );
      });

      group('when is tapped', () {
        final currentDate = DateTime.now();
        final newActivity = Activity(
          userID: 'id',
          date: DateTime.utc(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          ),
          startTime: DateTime(1970, 1, 1, 7),
          endTime: DateTime(1970, 1, 1, 8),
        );

        testWidgets(
            'shows ActivityPage dialog '
            'when size is large', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));

          await tester.pump();

          final activityPage = tester.widget<ActivityPage>(
            find.byType(ActivityPage),
          );

          expect(activityPage.isDialog, equals(true));
        });

        testWidgets(
            'goes to activityPage '
            'and send newActivity as extra '
            'when size is not large', (tester) async {
          await tester.pumpApp(buildSubject(currentSize: PlannerSize.small));

          await tester.tap(find.widgetWithText(ElevatedButton, 'Add'));

          verify(
            () => goRouter.goNamed(
              AppRoutes.activity,
              params: {'page': 'planner'},
              extra: newActivity,
            ),
          ).called(1);
        });
      });
    });
  });
}
