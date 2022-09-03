import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';

class ActivityAllDaySwitch extends StatelessWidget {
  const ActivityAllDaySwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isAllDay = context.select((ActivityBloc bloc) => bloc.state.isAllDay);
    return Row(
      children: [
        Text(
          'All-day activity:',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 20),
        const Spacer(),
        Switch(
          value: isAllDay,
          onChanged: (_) => context.read<ActivityBloc>().add(
                const ActivityAllDayToggled(),
              ),
        ),
      ],
    );
  }
}
