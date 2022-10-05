import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/settings/settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/helpers.dart';

void main() {
  group('SettingsRemindersTasks', () {
    late AppBloc appBloc;

    final defaultTasksReminderTimes = [
      DateTime(1970, 1, 1, 8),
      DateTime(1970, 1, 1, 12),
      DateTime(1970, 1, 1, 20),
    ];

    final defaultTaskReminderValues = [false, false, false];

    setUp(() {
      appBloc = MockAppBloc();

      when(() => appBloc.state).thenReturn(const AppState());
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: appBloc,
        child: const SettingsRemindersTasks(),
      );
    }

    group('Switch button', () {
      testWidgets('renders correct title', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.text('Tasks reminders'), findsOneWidget);
      });

      testWidgets('is rendered', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byType(Switch), findsOneWidget);
      });

      testWidgets(
          'adds AppTasksRemindersAllowed to AppBloc '
          'when isPressed and tasksReminders are disabled', (tester) async {
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(Switch));

        verify(() => appBloc.add(const AppTasksRemindersAllowed()));
      });

      testWidgets(
          'adds AppTasksRemindersDisabled to AppBloc '
          'when isPressed and tasksReminders are allowed', (tester) async {
        when(() => appBloc.state).thenReturn(
          AppState(
            tasksReminderValues: defaultTaskReminderValues,
            tasksReminderTimes: defaultTasksReminderTimes,
          ),
        );
        await tester.pumpApp(buildSubject());

        await tester.tap(find.byType(Switch));

        verify(() => appBloc.add(const AppTasksRemindersDisabled()));
      });
    });

    group('Tasks reminders', () {
      setUp(() {
        when(() => appBloc.state).thenReturn(
          AppState(
            tasksReminderValues: defaultTaskReminderValues,
            tasksReminderTimes: defaultTasksReminderTimes,
          ),
        );
      });
      testWidgets('arre rendered when they are allowed', (tester) async {
        await tester.pumpApp(buildSubject());

        expect(find.byKey(const Key('task_reminder:0')), findsOneWidget);
        expect(find.byKey(const Key('task_reminder:1')), findsOneWidget);
        expect(find.byKey(const Key('task_reminder:2')), findsOneWidget);
      });

      group('first reminder', () {
        testWidgets(
            'adds AppTaskReminderValueChanged to AppBloc '
            'when checkbox is pressed.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:0')),
              matching: find.byType(Checkbox),
            ),
          );

          verify(
            () => appBloc
                .add(const AppTaskReminderValueChanged(index: 0, value: true)),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new hour is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:0')),
              matching: find.text('8').hitTestable(),
            ),
          );

          final newHourFinder = find.text('9').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newHourFinder);

          await tester.pumpAndSettle();

          await tester.tap(newHourFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 0,
                time: DateTime(1970, 1, 1, 9),
              ),
            ),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new minute is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:0')),
              matching: find.text('0').hitTestable(),
            ),
          );

          final newMinuteFinder = find.text('10').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newMinuteFinder);

          await tester.pumpAndSettle();

          await tester.tap(newMinuteFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 0,
                time: DateTime(1970, 1, 1, 8, 10),
              ),
            ),
          );
        });
      });

      group('second reminder', () {
        testWidgets(
            'adds AppTaskReminderValueChanged to AppBloc '
            'when checkbox is pressed.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:1')),
              matching: find.byType(Checkbox),
            ),
          );

          verify(
            () => appBloc
                .add(const AppTaskReminderValueChanged(index: 1, value: true)),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new hour is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:1')),
              matching: find.text('12').hitTestable(),
            ),
          );

          final newHourFinder = find.text('14').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newHourFinder);

          await tester.pumpAndSettle();

          await tester.tap(newHourFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 1,
                time: DateTime(1970, 1, 1, 14),
              ),
            ),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new minute is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:1')),
              matching: find.text('0').hitTestable(),
            ),
          );

          final newMinuteFinder = find.text('10').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newMinuteFinder);

          await tester.pumpAndSettle();

          await tester.tap(newMinuteFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 1,
                time: DateTime(1970, 1, 1, 12, 10),
              ),
            ),
          );
        });
      });

      group('third reminder', () {
        testWidgets(
            'adds AppTaskReminderValueChanged to AppBloc '
            'when checkbox is pressed.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:2')),
              matching: find.byType(Checkbox),
            ),
          );

          verify(
            () => appBloc
                .add(const AppTaskReminderValueChanged(index: 2, value: true)),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new hour is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:2')),
              matching: find.text('20').hitTestable(),
            ),
          );

          final newHourFinder = find.text('18').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newHourFinder);

          await tester.pumpAndSettle();

          await tester.tap(newHourFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 2,
                time: DateTime(1970, 1, 1, 18),
              ),
            ),
          );
        });

        testWidgets(
            'adds AppTaskReminderTimeChanged to AppBloc '
            'when a new minute is selected.', (tester) async {
          await tester.pumpApp(buildSubject());

          await tester.tap(
            find.descendant(
              of: find.byKey(const Key('task_reminder:2')),
              matching: find.text('0').hitTestable(),
            ),
          );

          final newMinuteFinder = find.text('10').hitTestable();

          await tester.pump();

          await tester.ensureVisible(newMinuteFinder);

          await tester.pumpAndSettle();

          await tester.tap(newMinuteFinder);

          verify(
            () => appBloc.add(
              AppTaskReminderTimeChanged(
                index: 2,
                time: DateTime(1970, 1, 1, 20, 10),
              ),
            ),
          );
        });
      });
    });
  });
}
