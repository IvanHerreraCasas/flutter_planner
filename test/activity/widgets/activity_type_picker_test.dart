import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityTypePicker', () {
    late ActivityBloc activityBloc;

    setUp(() {
      activityBloc = MockActivityBloc();

      when(() => activityBloc.state).thenReturn(mockActivityState);
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: activityBloc,
        child: const ActivityTypePicker(),
      );
    }

    testWidgets('shows correct type', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Task').hitTestable(), findsOneWidget);
    });

    testWidgets(
        'adds ActivityTypeChanged to ActivityBloc '
        'when a new type is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.text('Task'));

      await tester.pumpAndSettle();

      await tester.tap(find.text('Event').hitTestable());

      verify(() => activityBloc.add(const ActivityTypeChanged(1))).called(1);
    });
  });
}
