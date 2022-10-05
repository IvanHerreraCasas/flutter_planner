import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockingjay/mockingjay.dart';

import '../../helpers/helpers.dart';

void main() {
  group('RemindersList', () {
    late RemindersCubit remindersCubit;

    setUp(() {
      remindersCubit = MockRemindersCubit();
    });

    Widget buildSubject({bool isAllDay = false}) {
      return BlocProvider.value(
        value: remindersCubit,
        child: RemindersList(isAllDay: isAllDay),
      );
    }

    group('when it is all day', () {
      final reminderValues = [true, false, true, false, false];
      setUp(() {
        when(() => remindersCubit.state).thenReturn(
          RemindersState(reminderValues: reminderValues),
        );
      });
      group('That day at 08:00 reminder', () {
        const key = Key('That day at 08:00');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change 0 reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(0));
        });
      });

      group('1 day before at 08:00 reminder', () {
        const key = Key('1 day before at 08:00');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [1] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(1));
        });
      });

      group('2 days before at 08:00 reminder', () {
        const key = Key('2 days before at 08:00');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [2] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(2));
        });
      });

      group('3 days before at 08:00 reminder', () {
        const key = Key('3 days before at 08:00');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [3] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(3));
        });
      });

      group('7 days before at 08:00 reminder', () {
        const key = Key('7 days before at 08:00');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [4] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject(isAllDay: true));

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(4));
        });
      });
    });

    group('when is not all day', () {
      final reminderValues = [
        true,
        false,
        true,
        false,
        false,
        true,
        false,
        true,
        false,
      ];

      setUp(() {
        when(() => remindersCubit.state).thenReturn(
          RemindersState(reminderValues: reminderValues),
        );
      });
      group('before the event reminder', () {
        const key = Key('before the event');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [0] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(0));
        });
      });

      group('5 minutes before reminder', () {
        const key = Key('5 minutes before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [1] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(1));
        });
      });

      group('15 minutes before reminder', () {
        const key = Key('15 minutes before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [2] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(2));
        });
      });

      group('30 minutes before reminder', () {
        const key = Key('30 minutes before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [3] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(3));
        });
      });

      group('1 hour before reminder', () {
        const key = Key('1 hour before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [4] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(4));
        });
      });

      group('4 hours before reminder', () {
        const key = Key('4 hours before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [5] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(5));
        });
      });

      group('1 day before reminder', () {
        const key = Key('1 day before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [6] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(6));
        });
      });

      group('2 days before reminder', () {
        const key = Key('2 days before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [7] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(7));
        });
      });

      group('1 week before reminder', () {
        const key = Key('1 week before');
        testWidgets('is rendered', (tester) async {
          await tester.pumpApp(buildSubject());

          expect(find.byKey(key), findsOneWidget);
        });

        testWidgets('change [8] reminder value when checkbox is pressed',
            (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(find.byKey(Key('checkbox: $key')));

          verify(() => remindersCubit.changeReminderValue(8));
        });
      });
    });
  });
}
