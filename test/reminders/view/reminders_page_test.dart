import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('RemindersPage', () {
    Widget buildSubject({
      List<bool> reminderValues = const [],
      bool isAllDay = true,
    }) {
      return RemindersPage(
        reminderValues: reminderValues,
        isAllDay: isAllDay,
      );
    }

    testWidgets('renders RemindersView', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(RemindersView), findsOneWidget);
    });
  });

  group('RemindersView', () {
    late RemindersCubit remindersCubit;

    setUp(() {
      remindersCubit = MockRemindersCubit();

      when(() => remindersCubit.state).thenReturn(const RemindersState());
    });

    Widget buildSubject({bool isAllDay = true}) {
      return BlocProvider.value(
        value: remindersCubit,
        child: RemindersView(isAllDay: isAllDay),
      );
    }

    testWidgets('renders reminders header and list', (tester) async {
      await tester.pumpApp(buildSubject());

      expect(find.byType(RemindersHeader), findsOneWidget);
      expect(find.byType(RemindersList), findsOneWidget);
    });
  });
}
