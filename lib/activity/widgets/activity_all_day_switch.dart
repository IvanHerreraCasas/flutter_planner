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
        Expanded(
          child: Text(
            'All-day activity:',
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 20),
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
