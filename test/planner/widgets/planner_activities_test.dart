import 'package:activities_repository/activities_repository.dart';
import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

void main() {
  group('PlannerActivities', () {
    late AppBloc appBloc;
    late PlannerBloc plannerBloc;

    final mockActivities = [
      Activity(
        userID: 'userID',
        id: 1,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 9),
      ),
      Activity(
        userID: 'userID',
        id: 2,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970, 1, 1, 10),
        endTime: DateTime(1970, 1, 1, 11),
      ),
      Activity(
        userID: 'userID',
        id: 3,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
      ),
      Activity(
        userID: 'userID',
        id: 4,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970),
        endTime: DateTime(1970),
      ),
      Activity(
        userID: 'userID',
        id: 5,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970),
        endTime: DateTime(1970),
      ),
    ];

    setUp(() {
      appBloc = MockAppBloc();
      plannerBloc = MockPlannerBloc();

      when(() => appBloc.state).thenReturn(const AppState());
      when(() => plannerBloc.state).thenReturn(
        PlannerState(
          activities: mockActivities,
        ),
      );
    });

    Widget buildSubject({
      PlannerSize currentSize = PlannerSize.large,
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appBloc),
          BlocProvider.value(value: plannerBloc),
        ],
        child: PlannerActivities(currentSize: currentSize),
      );
    }

    testWidgets(
        'renders DynamicTimeline with ActivityCards '
        'of non allDay activities', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(DynamicTimeline), findsOneWidget);
      expect(
        find.descendant(
          of: find.byType(DynamicTimeline),
          matching: find.byType(ActivityCard),
        ),
        findsNWidgets(3),
      );
    });

    testWidgets('renders ActivityCards of all activities.', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.byType(ActivityCard),
        findsNWidgets(mockActivities.length),
      );
    });
  });
}
