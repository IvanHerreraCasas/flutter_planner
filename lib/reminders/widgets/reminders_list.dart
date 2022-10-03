import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/reminders/reminders.dart';

class RemindersList extends StatelessWidget {
  const RemindersList({
    Key? key,
    required this.isAllDay,
  }) : super(key: key);

  final bool isAllDay;

  @override
  Widget build(BuildContext context) {
    final reminderValues = context.select(
      (RemindersCubit cubit) => cubit.state.reminderValues,
    );

    if (isAllDay && reminderValues.length >= 5) {
      return ListView(
        children: [
          ReminderCheckbox(
            key: const Key('That day at 08:00'),
            title: 'That day at 08:00',
            value: reminderValues[0],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(0),
          ),
          ReminderCheckbox(
            key: const Key('1 day before at 08:00'),
            title: '1 day before at 08:00',
            value: reminderValues[1],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(1),
          ),
          ReminderCheckbox(
            key: const Key('2 days before at 08:00'),
            title: '2 days before at 08:00',
            value: reminderValues[2],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(2),
          ),
          ReminderCheckbox(
            key: const Key('3 days before at 08:00'),
            title: '3 days before at 08:00',
            value: reminderValues[3],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(3),
          ),
          ReminderCheckbox(
            key: const Key('7 days before at 08:00'),
            title: '7 days before at 08:00',
            value: reminderValues[4],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(4),
          ),
        ],
      );
    } else if (reminderValues.length >= 9) {
      return ListView(
        children: [
          ReminderCheckbox(
            key: const Key('before the event'),
            title: 'before the event',
            value: reminderValues[0],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(0),
          ),
          ReminderCheckbox(
            key: const Key('5 minutes before'),
            title: '5 minutes before',
            value: reminderValues[1],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(1),
          ),
          ReminderCheckbox(
            key: const Key('15 minutes before'),
            title: '15 minutes before',
            value: reminderValues[2],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(2),
          ),
          ReminderCheckbox(
            key: const Key('30 minutes before'),
            title: '30 minutes before',
            value: reminderValues[3],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(3),
          ),
          ReminderCheckbox(
            key: const Key('1 hour before'),
            title: '1 hour before',
            value: reminderValues[4],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(4),
          ),
          ReminderCheckbox(
            key: const Key('4 hours before'),
            title: '4 hours before',
            value: reminderValues[5],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(5),
          ),
          ReminderCheckbox(
            key: const Key('1 day before'),
            title: '1 day before',
            value: reminderValues[6],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(6),
          ),
          ReminderCheckbox(
            key: const Key('2 days before'),
            title: '2 days before',
            value: reminderValues[7],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(7),
          ),
          ReminderCheckbox(
            key: const Key('1 week before'),
            title: '1 week before',
            value: reminderValues[8],
            onChanged: (_) =>
                context.read<RemindersCubit>().changeReminderValue(8),
          ),
        ],
      );
    }

    return const SizedBox();
  }
}

class ReminderCheckbox extends StatelessWidget {
  const ReminderCheckbox({
    Key? key,
    required this.title,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  final String title;
  final bool value;
  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(width: 10),
        const Spacer(),
        Checkbox(
          key: Key('checkbox: $key'),
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        )
      ],
    );
  }
}
