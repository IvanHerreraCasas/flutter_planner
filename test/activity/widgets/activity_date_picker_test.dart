import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/widgets/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';
import '../activity_mocks.dart';

void main() {
  group('ActivityDatePicker', () {
    late ActivityBloc activityBloc;
    late DateTime date;

    setUp(() {
      activityBloc = MockActivityBloc();

      when(() => activityBloc.state).thenReturn(mockActivityState);

      date = activityBloc.state.date;
    });

    Widget buildSubject({
      bool isDialog = false,
    }) {
      return BlocProvider.value(
        value: activityBloc,
        child: ActivityDatePicker(
          isDialog: isDialog,
        ),
      );
    }

    testWidgets('shows correct date', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(
        find.text(DateFormat('MM-dd-yyyy').format(date)),
        findsOneWidget,
      );
    });

    testWidgets('is disabled when is dialog', (tester) async {
      await tester.pumpApp(buildSubject(isDialog: true));

      final customDatePicker =
          tester.widget<CustomDatePicker>(find.byType(CustomDatePicker));

      expect(customDatePicker.enabled, equals(false));
    });

    testWidgets(
        'adds ActivityDateChanged '
        'to ActivityBloc '
        'when new date is selected', (tester) async {
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byType(ElevatedButton));

      await tester.pump();

      await tester.tap(find.text('5'));

      await tester.tap(find.text('OK'));

      final newDate = DateTime(date.year, date.month, 5);

      verify(() => activityBloc.add(ActivityDateChanged(newDate))).called(1);
    });
  });
}
