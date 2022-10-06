import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';

class RoutineDayPicker extends StatelessWidget {
  const RoutineDayPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final day = context.select((RoutineBloc bloc) => bloc.state.day);
    return Row(
      children: [
        Expanded(
          child: Text(
            'Day: ',
            style: Theme.of(context).textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 20),
        DropdownButton2<int>(
          value: day - 1,
          dropdownWidth: 150,
          onChanged: (value) {
            if (value != null) {
              context.read<RoutineBloc>().add(RoutineDayChanged(value + 1));
            }
          },
          items: List.generate(
            7,
            (index) {
              late final String dayString;

              switch (index) {
                case 0:
                  dayString = 'Monday';
                  break;
                case 1:
                  dayString = 'Tuesday';
                  break;
                case 2:
                  dayString = 'Wednesday';
                  break;
                case 3:
                  dayString = 'Thursday';
                  break;
                case 4:
                  dayString = 'Friday';
                  break;
                case 5:
                  dayString = 'Saturday';
                  break;
                case 6:
                  dayString = 'Sunday';
                  break;
              }

              return DropdownMenuItem(
                value: index,
                child: Text(dayString),
              );
            },
          ),
        ),
      ],
    );
  }
}
