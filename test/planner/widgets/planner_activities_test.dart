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
        id: 2,
        date: DateTime.utc(2022, 6, 16),
        startTime: DateTime(1970, 1, 1, 11),
        endTime: DateTime(1970, 1, 1, 12),
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

    testWidgets('renders DynamicTimeline with ActivitCards', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(DynamicTimeline), findsOneWidget);
      expect(
        find.byType(ActivityCard),
        findsNWidgets(mockActivities.length),
      );
    });
  });
}
