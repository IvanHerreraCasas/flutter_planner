import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';

class PlannerTabs extends StatelessWidget {
  const PlannerTabs({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final PlannerSize currentSize;

  @override
  Widget build(BuildContext context) {
    final selectedTab = context.select(
      (PlannerBloc bloc) => bloc.state.selectedTab,
    );

    final theme = Theme.of(context);

    final tabs = [
      const PlannerTasks(),
      PlannerActivities(currentSize: currentSize),
    ];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Row(
                children: [
                  Flexible(
                    child: GestureDetector(
                      onTap: () => context.read<PlannerBloc>().add(
                            const PlannerSelectedTabChanged(0),
                          ),
                      child: Text(
                        'Tasks',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: selectedTab == 0
                              ? theme.colorScheme.onBackground
                              : theme.colorScheme.outline,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Flexible(
                    child: GestureDetector(
                      onTap: () => context.read<PlannerBloc>().add(
                            const PlannerSelectedTabChanged(1),
                          ),
                      child: Text(
                        'Activities',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: selectedTab == 1
                              ? theme.colorScheme.onBackground
                              : theme.colorScheme.outline,
                        ),
                        softWrap: false,
                        overflow: TextOverflow.fade,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: selectedTab == 1,
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              child: ElevatedButton(
                onPressed: () => context.read<PlannerBloc>().add(
                      const PlannerAddRoutines(),
                    ),
                child: const Text('+ routines'),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 25,
        ),
        Expanded(
          child: IndexedStack(
            index: selectedTab,
            children: tabs,
          ),
        ),
      ],
    );
  }
}
