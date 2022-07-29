import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/app.dart';

class AppearanceTimeline extends StatelessWidget {
  const AppearanceTimeline({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final startHour = context.select(
      (AppBloc bloc) => bloc.state.timelineStartHour,
    );
    final endHour = context.select(
      (AppBloc bloc) => bloc.state.timelineEndHour,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Timeline',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Text(
              'Start time: ',
              style: textTheme.titleMedium,
            ),
            const Spacer(),
            DropdownButton2<int>(
              key: const Key('start time hour'),
              value: startHour,
              dropdownMaxHeight: 200,
              buttonWidth: 70,
              items: List.generate(
                25,
                (index) => DropdownMenuItem(
                  value: index,
                  enabled: index < endHour,
                  child: Text(
                    '$index h',
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
              onChanged: (value) {
                context.read<AppBloc>().add(
                      AppTimelineStartHourChanged(value ?? startHour),
                    );
              },
            )
          ],
        ),
        Row(
          children: [
            Text(
              'End time: ',
              style: textTheme.titleMedium,
            ),
            const Spacer(),
            DropdownButton2<int>(
              key: const Key('end time hour'),
              value: endHour,
              dropdownMaxHeight: 200,
              buttonWidth: 70,
              items: List.generate(
                25,
                (index) => DropdownMenuItem(
                  value: index,
                  enabled: index > startHour,
                  child: Text('$index h'),
                ),
              ),
              onChanged: (value) {
                context.read<AppBloc>().add(
                      AppTimelineEndHourChanged(value ?? endHour),
                    );
              },
            )
          ],
        ),
      ],
    );
  }
}
