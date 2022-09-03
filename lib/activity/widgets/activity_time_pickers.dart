import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class ActivityTimePickers extends StatelessWidget {
  const ActivityTimePickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTime = context.select(
      (ActivityBloc bloc) => bloc.state.startTime,
    );

    final endTime = context.select(
      (ActivityBloc bloc) => bloc.state.endTime,
    );

    final isAllDay = context.select((ActivityBloc bloc) => bloc.state.isAllDay);

    return Visibility(
      visible: !isAllDay,
      child: Column(
        children: [
          DropdownTimePicker(
            key: const Key('start time picker'),
            time: startTime,
            onChanged: (dateTime) => context
                .read<ActivityBloc>()
                .add(ActivityStartTimeChanged(dateTime)),
            title: 'Start time: ',
            enableHour: (hour) {
              if (startTime.minute < endTime.minute) {
                return endTime.hour >= hour;
              }
              return endTime.hour > hour;
            },
            enableMinute: (minute) {
              if (startTime.hour < endTime.hour) {
                return true;
              }
              // case: startTime.hour == endTime.hour
              return endTime.minute > minute;
            },
          ),
          DropdownTimePicker(
            key: const Key('end time picker'),
            time: endTime,
            onChanged: (dateTime) => context
                .read<ActivityBloc>()
                .add(ActivityEndTimeChanged(dateTime)),
            title: 'End time: ',
            enableHour: (hour) {
              if (startTime.minute < endTime.minute) {
                return startTime.hour <= hour;
              }
              return startTime.hour < hour;
            },
            enableMinute: (minute) {
              if (startTime.hour < endTime.hour) {
                return true;
              }
              // case: startTime.hour == endTime.hour
              return startTime.minute < minute;
            },
          ),
        ],
      ),
    );
  }
}
