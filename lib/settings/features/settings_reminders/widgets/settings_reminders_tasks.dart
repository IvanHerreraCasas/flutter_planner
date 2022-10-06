import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class SettingsRemindersTasks extends StatelessWidget {
  const SettingsRemindersTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final tasksReminderTimes = context.select(
      (AppBloc bloc) => bloc.state.tasksReminderTimes,
    );

    final tasksReminderValues = context.select(
      (AppBloc bloc) => bloc.state.tasksReminderValues,
    );

    final tasksReminderAreAllowed = context.select(
      (AppBloc bloc) => bloc.state.tasksRemindersAreAllowed,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Tasks reminders',
                style: textTheme.titleLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Switch(
              value: tasksReminderAreAllowed,
              onChanged: (value) {
                if (value) {
                  context.read<AppBloc>().add(const AppTasksRemindersAllowed());
                } else {
                  context.read<AppBloc>().add(
                        const AppTasksRemindersDisabled(),
                      );
                }
              },
            ),
          ],
        ),
        const SizedBox(height: 20),
        if (tasksReminderAreAllowed)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TasksReminder(
                key: const Key('task_reminder:0'),
                value: tasksReminderValues[0],
                time: tasksReminderTimes[0],
                onChangedValue: (value) => context.read<AppBloc>().add(
                      AppTaskReminderValueChanged(index: 0, value: value),
                    ),
                onChangedTime: (time) => context.read<AppBloc>().add(
                      AppTaskReminderTimeChanged(index: 0, time: time),
                    ),
              ),
              const SizedBox(height: 10),
              TasksReminder(
                key: const Key('task_reminder:1'),
                value: tasksReminderValues[1],
                time: tasksReminderTimes[1],
                onChangedValue: (value) => context.read<AppBloc>().add(
                      AppTaskReminderValueChanged(index: 1, value: value),
                    ),
                onChangedTime: (time) => context.read<AppBloc>().add(
                      AppTaskReminderTimeChanged(index: 1, time: time),
                    ),
              ),
              const SizedBox(height: 10),
              TasksReminder(
                key: const Key('task_reminder:2'),
                value: tasksReminderValues[2],
                time: tasksReminderTimes[2],
                onChangedValue: (value) => context.read<AppBloc>().add(
                      AppTaskReminderValueChanged(index: 2, value: value),
                    ),
                onChangedTime: (time) => context.read<AppBloc>().add(
                      AppTaskReminderTimeChanged(index: 2, time: time),
                    ),
              ),
              const SizedBox(height: 10),
            ],
          )
      ],
    );
  }
}

class TasksReminder extends StatelessWidget {
  const TasksReminder({
    Key? key,
    required this.value,
    required this.time,
    required this.onChangedValue,
    required this.onChangedTime,
  }) : super(key: key);

  final bool value;

  final DateTime time;

  final void Function(bool value) onChangedValue;

  final void Function(DateTime time) onChangedTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (value) => value != null ? onChangedValue(value) : null,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: DropdownTimePicker(
            time: time,
            enableHour: (hour) => true,
            enableMinute: (minute) => true,
            onChanged: onChangedTime,
            title: 'Every day at ',
          ),
        ),
      ],
    );
  }
}
