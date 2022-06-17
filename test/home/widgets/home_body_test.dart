import 'package:activities_repository/activities_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_planner/home/home.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomeBody', () {
    late ActivitiesRepository activitiesRepository;
    late RoutinesRepository routinesRepository;

    setUp(() {
      activitiesRepository = MockActivitiesRepository();
      routinesRepository = MockRoutinesRepository();

      when(
        () => activitiesRepository.streamActivities(date: any(named: 'date')),
      ).thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => activitiesRepository.dispose()).thenAnswer((_) async {});
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    Widget buildSubject({
      int index = 0,
    }) {
      return HomeBody(index: index);
    }

    testWidgets('renders and show PlannerPager when index is 0',
        (tester) async {
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpApp(
        buildSubject(),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
      );

      expect(find.byType(PlannerPage), findsOneWidget);
    });

    testWidgets('renders and shows SchedulePage when index is 1',
        (tester) async {
      await tester.pumpApp(
        buildSubject(index: 1),
        activitiesRepository: activitiesRepository,
        routinesRepository: routinesRepository,
      );

      expect(find.byType(SchedulePage), findsOneWidget);
    });
  });
}
