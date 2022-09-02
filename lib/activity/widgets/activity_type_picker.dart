import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';

class ActivityTypePicker extends StatelessWidget {
  const ActivityTypePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final type = context.select((ActivityBloc bloc) => bloc.state.type);

    return Row(
      children: [
        Text(
          'Type:',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        const SizedBox(width: 20),
        const Spacer(),
        DropdownButton2<int>(
          value: type,
          buttonWidth: 100,
          onChanged: (value) {
            if (value != null) {
              context.read<ActivityBloc>().add(
                    ActivityTypeChanged(value),
                  );
            }
          },
          items: const <DropdownMenuItem<int>>[
            DropdownMenuItem(
              value: 0,
              child: Text('Task'),
            ),
            DropdownMenuItem(
              value: 1,
              child: Text('Event'),
            ),
            DropdownMenuItem(
              value: 2,
              child: Text('Routine'),
            ),
          ],
        ),
      ],
    );
  }
}
