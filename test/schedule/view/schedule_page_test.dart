import 'package:flutter/material.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('SchedulePage', () {
    late RoutinesRepository routinesRepository;

    setUp(() {
      routinesRepository = MockRoutinesRepository();

      when(() => routinesRepository.streamRoutines())
          .thenAnswer((_) => const Stream.empty());
      when(() => routinesRepository.dispose()).thenAnswer((_) async {});
    });

    Widget buildSubject() {
      return const SchedulePage();
    }

    testWidgets('renders ScheduleLayoutBuilder with correct widgets',
        (tester) async {
      await tester.pumpApp(
        buildSubject(),
        routinesRepository: routinesRepository,
      );

      expect(find.byType(ScheduleLayoutBuilder), findsOneWidget);
      expect(find.byType(ScheduleHeader), findsOneWidget);
      expect(find.byType(ScheduleTimetable), findsOneWidget);
      expect(find.byType(ScheduleSidePane), findsOneWidget);
    });
  });
}
