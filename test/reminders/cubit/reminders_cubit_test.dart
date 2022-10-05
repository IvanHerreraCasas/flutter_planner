import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemindersCubit', () {
    final reminderValues = [true, true, false];

    RemindersCubit buildCubit() {
      return RemindersCubit(reminderValues: reminderValues);
    }

    group('constructor', () {
      test('works normally', () {
        expect(buildCubit, returnsNormally);
      });

      test('has correct initial state', () {
        expect(
          buildCubit().state,
          equals(RemindersState(reminderValues: reminderValues)),
        );
      });
    });

    group('changeReminderValue', () {
      blocTest<RemindersCubit, RemindersState>(
        'change the value of the given index '
        'and emit new state with update reminderValues',
        build: buildCubit,
        act: (cubit) => cubit.changeReminderValue(1),
        expect: () => const <RemindersState>[
          RemindersState(
            reminderValues: [true, false, false],
          ),
        ],
      );
    });
  });
}
