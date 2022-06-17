import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class RoutineTimePickers extends StatelessWidget {
  const RoutineTimePickers({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startTime = context.select(
      (RoutineBloc bloc) => bloc.state.startTime,
    );

    final endTime = context.select(
      (RoutineBloc bloc) => bloc.state.endTime,
    );

    return Column(
      children: [
        DropdownTimePicker(
          key: const Key('start time picker'),
          time: startTime,
          onChanged: (value) => context.read<RoutineBloc>().add(
                RoutineStartTimeChanged(value),
              ),
          title: 'Start Time: ',
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
          onChanged: (value) => context.read<RoutineBloc>().add(
                RoutineEndTimeChanged(value),
              ),
          title: 'End Time: ',
          enableHour: (hour) {
            if (startTime.minute == endTime.minute) {
              return startTime.hour < hour;
            }
            return startTime.hour <= hour;
          },
          enableMinute: (minute) {
            if (startTime.hour == endTime.hour) {
              return startTime.minute < minute;
            }
            return startTime.minute <= minute;
          },
        ),
      ],
    );
  }
}
