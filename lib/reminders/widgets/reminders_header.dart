import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';

class RemindersHeader extends StatelessWidget {
  const RemindersHeader({Key? key}) : super(key: key);

  int _countValues(List<bool> values) {
    var count = 0;

    for (final value in values) {
      if (value) count++;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final reminderValues = context.select(
      (RemindersCubit cubit) => cubit.state.reminderValues,
    );
    final count = _countValues(reminderValues);
    return Row(
      children: [
        Text(
          'Reminders:',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 10),
        const Spacer(),
        Text(
          count.toString(),
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 5),
        Icon(
          count > 0 ? Icons.notifications_active : Icons.notifications_none,
        ),
      ],
    );
  }
}
