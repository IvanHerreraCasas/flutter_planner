import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:routines_api/routines_api.dart';

import '../../helpers/helpers.dart';
import '../schedule_mocks.dart';

void main() {
  group('ScheduleSidePane', () {
    late ScheduleBloc scheduleBloc;

    final mockRoutine = Routine(
      userID: 'userID',
      name: 'name',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 8),
    );

    setUp(() {
      scheduleBloc = MockScheduleBloc();

      when(() => scheduleBloc.state).thenReturn(const ScheduleState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: scheduleBloc,
        child: const ScheduleSidePane(),
      );
    }

    testWidgets(
        'renders a RoutinePage '
        'when selectedRoutine is not null', (tester) async {
      when(() => scheduleBloc.state).thenReturn(
        ScheduleState(selectedRoutine: mockRoutine),
      );
      FlutterError.onError = ignoreOverflowErrors;
      await tester.pumpApp(buildSubject());

      expect(find.byType(RoutinePage), findsOneWidget);
    });

    testWidgets('renders SizedBox with non size', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(SizedBox), findsOneWidget);

      final renderBox = tester.renderObject<RenderBox>(find.byType(SizedBox));

      expect(renderBox.size, Size.zero);
    });
  });
}
