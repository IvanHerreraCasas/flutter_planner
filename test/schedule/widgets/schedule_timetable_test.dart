import 'package:dynamic_timeline/dynamic_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_repository/routines_repository.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ScheduleTimetable', () {
    late AppBloc appBloc;
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
      appBloc = MockAppBloc();
      scheduleBloc = MockScheduleBloc();

      when(() => appBloc.state).thenReturn(const AppState());
      when(() => scheduleBloc.state).thenReturn(
        ScheduleState(
          routines: mockRoutines,
        ),
      );
    });

    Widget buildSubject({
      ScheduleSize currentSize = ScheduleSize.small,
    }) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: appBloc),
          BlocProvider.value(value: scheduleBloc),
        ],
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

    testWidgets(
        'add ScheduleRoutineChanged '
        'to ScheduleBloc when the top is dragged', (tester) async {
      await tester.pumpApp(buildSubject());

      final centerLocation = tester.getCenter(
        find.byKey(ValueKey(mockRoutines[0])),
      );

      final topLocation = centerLocation.translate(0, -50);

      await tester.dragFrom(topLocation, const Offset(0, -25));

      // interval extent is 50 pixels and intervalDuration is 1 hour
      // => 25 pixels = 30 min
      verify(
        () => scheduleBloc.add(
          ScheduleRoutineChanged(
            mockRoutines[0].copyWith(
              startTime: DateTime(1970, 1, 1, 7, 30),
            ),
          ),
        ),
      ).called(1);
    });

    testWidgets(
        'add ScheduleRoutineChanged '
        'to ScheduleBloc when the bottom is dragged', (tester) async {
      await tester.pumpApp(buildSubject());

      final centerLocation = tester.getCenter(
        find.byKey(ValueKey(mockRoutines[0])),
      );
      // interval extent is 50 pixels and intervalDuration is 1 hour
      // mockRoutines[0] has a duration of 2 hour, the half is 50 pixels
      final bottomLocation = centerLocation.translate(0, 49);

      await tester.dragFrom(bottomLocation, const Offset(0, 25));

      // 25 pixels = 30 min
      verify(
        () => scheduleBloc.add(
          ScheduleRoutineChanged(
            mockRoutines[0].copyWith(
              endTime: DateTime(1970, 1, 1, 10, 30),
            ),
          ),
        ),
      ).called(1);
    });
  });
}
