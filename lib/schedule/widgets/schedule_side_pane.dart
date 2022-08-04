import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:routines_repository/routines_repository.dart';

class ScheduleSidePane extends StatelessWidget {
  const ScheduleSidePane({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final ScheduleSize currentSize;

  @override
  Widget build(BuildContext context) {
    final selectedRoutine = context.select(
      (ScheduleBloc bloc) => bloc.state.selectedRoutine,
    );

    if (selectedRoutine != null && currentSize != ScheduleSize.small) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        width: 300,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => context.read<ScheduleBloc>().add(
                    const ScheduleSelectedRoutineChanged(
                      null,
                    ),
                  ),
              splashRadius: 5,
              iconSize: 15,
              icon: const Icon(Icons.close),
            ),
            Expanded(
              child: BlocProvider(
                key: ValueKey<Routine?>(selectedRoutine),
                create: (context) => RoutineBloc(
                  routinesRepository: context.read<RoutinesRepository>(),
                  initialRoutine: selectedRoutine,
                ),
                child: const RoutinePage(),
              ),
            )
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
