import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScheduleTimetable', () {
    late ScheduleBloc scheduleBloc;

    final mockRoutines = [
      Routine(
        userID: 'userID',
        id: 1,
        name: 'routine 1',
        day: 1,
        startTime: DateTime(1970, 1, 1, 8),
        endTime: DateTime(1970, 1, 1, 10),
      ),
      Routine(
        userID: 'userID',
        id: 2,
        name: 'routine 2',
        day: 3,
        startTime: DateTime(1970, 1, 1, 10),
        endTime: DateTime(1970, 1, 1, 12),
      ),
      Routine(
        userID: 'userID',
        id: 3,
        name: 'routine 3',
        day: 2,
        startTime: DateTime(1970, 1, 1, 9),
        endTime: DateTime(1970, 1, 1, 11),
      ),
    ];

    setUp(() {
      scheduleBloc = MockScheduleBloc();

      when(() => scheduleBloc.state).thenReturn(
        ScheduleState(
          routines: mockRoutines,
        ),
      );
    });

    Widget buildSubject({
      ScheduleSize currentSize = ScheduleSize.small,
    }) {
      return BlocProvider.value(
        value: scheduleBloc,
        child: ScheduleTimetable(
          currentSize: currentSize,
        ),
      );
    }

    testWidgets('renders DynamicTimeline with RoutineCards', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(DynamicTimeline), findsOneWidget);
      expect(find.byType(RoutineCard), findsNWidgets(3));
    });
  });
}
