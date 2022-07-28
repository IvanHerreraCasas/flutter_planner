import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tasks_repository/tasks_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerTabs', () {
    late AppBloc appBloc;
    late PlannerBloc plannerBloc;

    final mockDate = DateTime.utc(2022);

    final mockTasks = [
      Task(
        id: 1,
        userID: 'userID',
        title: 'task 1',
        date: mockDate,
        completed: true,
      ),
      Task(
        id: 2,
        userID: 'userID',
        title: 'task 2',
        date: mockDate,
        completed: true,
      ),
    ];

    final mockActivities = [
      Activity(
        id: 1,
        userID: 'userID',
        date: mockDate,
        startTime: DateTime(2022, 1, 1, 7),
        endTime: DateTime(2022, 1, 1, 8),
      ),
      Activity(
        id: 2,
        userID: 'userID',
        date: mockDate,
        startTime: DateTime(2022, 1, 1, 9),
        endTime: DateTime(2022, 1, 1, 10),
      ),
    ];

    setUp(() {
      appBloc = MockAppBloc();
      plannerBloc = MockPlannerBloc();

      when(() => appBloc.state).thenReturn(const AppState());
      when(() => plannerBloc.state).thenReturn(
        PlannerState(
          tasks: mockTasks,
          activities: mockActivities,
        ),
      );
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.small,
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appBloc),
          BlocProvider.value(value: plannerBloc),
        ],
        child: PlannerTabs(currentSize: currentSize),
      );
    }

    group('Tasks tab', () {
      testWidgets('renders Tasks title', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text('Tasks'), findsOneWidget);
      });

      testWidgets('renders tasks when is selected', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(TaskWidget), findsNWidgets(mockTasks.length));
      });

      testWidgets(
          'add PlannerSelectedTabChanged to PlannerBloc '
          'when Tasks title is pressed', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Tasks'));

        verify(
          () => plannerBloc.add(const PlannerSelectedTabChanged(0)),
        );
      });
    });

    group('Activities tab', () {
      testWidgets('renders Activities title', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text('Activities'), findsOneWidget);
      });

      testWidgets('renders activities when is selected', (tester) async {
        when(() => plannerBloc.state).thenReturn(
          PlannerState(activities: mockActivities, selectedTab: 1),
        );
        await tester.pumpApp(buildSubject());

        expect(find.byType(ActivityCard), findsNWidgets(mockTasks.length));
      });

      testWidgets(
          'renders ElevatedButton: + routines '
          'when is selected', (tester) async {
        when(() => plannerBloc.state).thenReturn(
          PlannerState(activities: mockActivities, selectedTab: 1),
        );
        await tester.pumpApp(buildSubject());

        expect(
          find.widgetWithText(ElevatedButton, '+ routines'),
          findsOneWidget,
        );
      });

      testWidgets(
          'add PlannerSelectedTabChanged to PlannerBloc '
          'when Activities title is pressed', (tester) async {
        when(() => plannerBloc.state).thenReturn(
          PlannerState(activities: mockActivities, selectedTab: 1),
        );
        await tester.pumpApp(buildSubject());

        await tester.tap(find.text('Activities'));

        verify(
          () => plannerBloc.add(const PlannerSelectedTabChanged(1)),
        );
      });

      testWidgets(
          'add PlannerAddRoutines to PlannerBloc '
          'when ElevatedButton: + routines is pressed', (tester) async {
        when(() => plannerBloc.state).thenReturn(
          PlannerState(activities: mockActivities, selectedTab: 1),
        );
        await tester.pumpApp(buildSubject());

        await tester.tap(find.widgetWithText(ElevatedButton, '+ routines'));

        verify(
          () => plannerBloc.add(const PlannerAddRoutines()),
        );
      });
    });
  });
}
