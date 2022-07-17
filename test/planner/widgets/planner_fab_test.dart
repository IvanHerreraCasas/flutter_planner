import 'package:activities_api/activities_api.dart';
import 'package:authentication_api/authentication_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:flutter_planner/authentication/authentication.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';
import '../planner_mocks.dart';

void main() {
  group('PlannerFAB', () {
    late GoRouter goRouter;
    late PlannerBloc plannerBloc;
    late AuthenticationBloc authenticationBloc;

    setUp(() {
      goRouter = MockGoRouter();
      plannerBloc = MockPlannerBloc();
      authenticationBloc = MockAuthenticationBloc();

      when(() => plannerBloc.state).thenReturn(PlannerState());
      when(() => authenticationBloc.state).thenReturn(
        const AuthenticationState.authenticated(User(id: 'id')),
      );
    });

    Widget buildSubject() {
      return InheritedGoRouter(
        goRouter: goRouter,
        child: MultiBlocProvider(
          providers: [
            BlocProvider.value(value: plannerBloc),
            BlocProvider.value(value: authenticationBloc)
          ],
          child: const Scaffold(
            floatingActionButton: PlannerFab(),
          ),
        ),
      );
    }

    testWidgets('renders FloatingActionButton', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    group('when is pressed', () {
      testWidgets(
          'add PlannerNewTaskAddded to PlannerBloc '
          'when selectedTab is 0', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(FloatingActionButton));

        verify(() => plannerBloc.add(const PlannerNewTaskAdded())).called(1);
      });

      testWidgets(
          'goes to activityPage '
          'and send newActivity as extra '
          'when selectedTab is 1', (tester) async {
        when(() => plannerBloc.state).thenReturn(
          PlannerState(selectedTab: 1),
        );
        final currentDate = DateTime.now();
        final newActivity = Activity(
          userID: 'id',
          date: DateTime(
            currentDate.year,
            currentDate.month,
            currentDate.day,
          ),
          startTime: DateTime(1970, 1, 1, 7),
          endTime: DateTime(1970, 1, 1, 8),
        );

        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(FloatingActionButton));

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
}
