import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityAllDaySwitch', () {
    late ActivityBloc activityBloc;

    setUp(() {
      activityBloc = MockActivityBloc();

      when(() => activityBloc.state).thenReturn(mockActivityState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: activityBloc,
        child: const ActivityAllDaySwitch(),
      );
    }

    testWidgets('renders a switch with correct value', (tester) async {
      await tester.pumpApp(buildSubject());

      final switchWidget = tester.widget<Switch>(find.byType(Switch));

      expect(switchWidget.value, false);
    });

    testWidgets(
        'adds ActivitiyAllDayToggled '
        'to ActivityBloc when is pressed', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(Switch));

      verify(
        () => activityBloc.add(const ActivityAllDayToggled()),
      ).called(1);
    });
  });
}
