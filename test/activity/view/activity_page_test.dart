import 'package:activities_api/activities_api.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

class MockActivityBloc extends MockBloc<ActivityEvent, ActivityState>
    implements ActivityBloc {}

class MockGoRouter extends Mock implements GoRouter {}

void main() {
  late ActivityBloc activityBloc;
  late GoRouter goRouter;
  late MockNavigator navigator;

  final mockActivity = Activity(
    userID: 'user_id',
    name: 'name',
    description: 'description',
    date: DateTime.utc(1970),
    startTime: DateTime(1970, 1, 1, 7),
    endTime: DateTime(1970, 1, 1, 8),
  );
  final mockActivityState = ActivityState(
    initialActivity: mockActivity,
    name: mockActivity.name,
    description: mockActivity.description,
    date: mockActivity.date,
    startTime: mockActivity.startTime,
    endTime: mockActivity.endTime,
  );

  setUp(() {
    activityBloc = MockActivityBloc();
    goRouter = MockGoRouter();
    navigator = MockNavigator();

    when(() => activityBloc.state).thenReturn(mockActivityState);
  });

  group('ActivityPage', () {
    Widget buildSubject({
      bool isDialog = false,
    }) {
      return MockNavigatorProvider(
        navigator: navigator,
        child: InheritedGoRouter(
          goRouter: goRouter,
          child: BlocProvider(
            create: (context) => activityBloc,
            child: ActivityPage(
              isDialog: isDialog,
            ),
          ),
        ),
      );
    }

    group('dialog', () {
      testWidgets('renders a Dialog', (tester) async {
        await tester.pumpApp(ActivityPage.dialog(activity: mockActivity));
        expect(find.byType(Dialog), findsOneWidget);
      });
      testWidgets('renders ActivityPage', (tester) async {
        await tester.pumpApp(ActivityPage.dialog(activity: mockActivity));
        expect(find.byType(ActivityPage), findsOneWidget);
      });
    });

    testWidgets('renders ActivityLayoutBuilder', (tester) async {
      FlutterError.onError = ignoreOverflowErrors;

      await tester.pumpApp(buildSubject());

      expect(find.byType(ActivityLayoutBuilder), findsOneWidget);
    });

    group('BlocListener', () {
      testWidgets('shows indicator when status change to loading',
          (tester) async {
        FlutterError.onError = ignoreOverflowErrors;
        whenListen(
          activityBloc,
          Stream.fromIterable([
            mockActivityState,
            mockActivityState.copyWith(status: ActivityStatus.loading),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });

      group('when status changes to success', () {
        testWidgets(
            'hide indicator and pops using goRouter '
            'when is not a dialog', (tester) async {
          FlutterError.onError = ignoreOverflowErrors;

          whenListen(
            activityBloc,
            Stream.fromIterable([
              mockActivityState.copyWith(status: ActivityStatus.loading),
              mockActivityState.copyWith(status: ActivityStatus.success),
            ]),
          );

          await tester.pumpApp(buildSubject());

          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsNothing);

          verify(() => goRouter.pop()).called(1);
        });

        testWidgets(
            'hide indicator and pops using navigator '
            'when is a dialog', (tester) async {
          FlutterError.onError = ignoreOverflowErrors;

          whenListen(
            activityBloc,
            Stream.fromIterable([
              mockActivityState.copyWith(status: ActivityStatus.loading),
              mockActivityState.copyWith(status: ActivityStatus.success),
            ]),
          );

          await tester.pumpApp(buildSubject(isDialog: true));

          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsNothing);

          verify(() => navigator.pop()).called(1);
        });
      });

      testWidgets(
          'hide indicator and shows a snackbar '
          'when status change to failure ', (tester) async {
        FlutterError.onError = ignoreOverflowErrors;

        whenListen(
          activityBloc,
          Stream.fromIterable([
            mockActivityState.copyWith(status: ActivityStatus.loading),
            mockActivityState.copyWith(status: ActivityStatus.failure),
          ]),
        );

        await tester.pumpApp(buildSubject());

        await tester.pump();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });
    });
  });
}
