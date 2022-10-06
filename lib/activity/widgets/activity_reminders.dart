import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/reminders/reminders.dart';
import 'package:reminders_repository/reminders_repository.dart';

class ActivityReminders extends StatelessWidget {
  const ActivityReminders({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final ActivitySize currentSize;

  int _countValues(List<bool> values) {
    var count = 0;

    for (final value in values) {
      if (value) count++;
    }

    return count;
  }

  @override
  Widget build(BuildContext context) {
    final areRemindersAllowed = context.read<RemindersRepository>().areAllowed;

    final reminderValues = context.select(
      (ActivityBloc bloc) => bloc.state.reminderValues,
    );

    final count = _countValues(reminderValues);

    final isAllDay = context.select(
      (ActivityBloc bloc) => bloc.state.isAllDay,
    );

    if (areRemindersAllowed &&
        reminderValues.isNotEmpty &&
        currentSize == ActivitySize.small) {
      return InkWell(
        onTap: () async {
          final activityBloc = context.read<ActivityBloc>();
          final _reminderValues = await showModalBottomSheet<List<bool>?>(
            context: context,
            elevation: 20,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            builder: (context) {
              return RemindersPage(
                reminderValues: reminderValues,
                isAllDay: isAllDay,
              );
            },
          );

          if (_reminderValues != null && !activityBloc.isClosed) {
            activityBloc.add(
              ActivityReminderValuesChanged(_reminderValues),
            );
          }
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                'Reminders: ',
                style: Theme.of(context).textTheme.bodyText1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(width: 5),
            Icon(
              count > 0 ? Icons.notifications_active : Icons.notifications_none,
            ),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
