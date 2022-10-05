import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('RemindersHeader', () {
    final reminderValues = [true, false, true];
    late RemindersCubit remindersCubit;

    setUp(() {
      remindersCubit = MockRemindersCubit();

      when(() => remindersCubit.state).thenReturn(
        RemindersState(reminderValues: reminderValues),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: remindersCubit,
        child: const RemindersHeader(),
      );
    }

    testWidgets('renders Reminders text', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('Reminders:'), findsOneWidget);
    });

    testWidgets('renders number of active reminders', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.text('2'), findsOneWidget);
    });

    testWidgets(
        'renders notification_active icon '
        'there are active reminders', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.notifications_active), findsOneWidget);
    });

    testWidgets(
        'renders notification_none icon '
        'when there arent active reminders', (tester) async {
      when(() => remindersCubit.state).thenReturn(
        const RemindersState(reminderValues: [false, false, false]),
      );

      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.notifications_none), findsOneWidget);
    });
  });
}
