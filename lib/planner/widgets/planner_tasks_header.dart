import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';

class PlannerTasksHeader extends StatelessWidget {
  const PlannerTasksHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Tasks',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => context.read<PlannerBloc>().add(
                const PlannerNewTaskAdded(),
              ),
          child: Text(
            '+ new',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
