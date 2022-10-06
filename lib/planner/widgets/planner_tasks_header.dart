import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';

class PlannerTasksHeader extends StatelessWidget {
  const PlannerTasksHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tasks',
            style: Theme.of(context).textTheme.titleLarge,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ElevatedButton(
          onPressed: () => context.read<PlannerBloc>().add(
                const PlannerNewTaskAdded(),
              ),
          child: const Text('+ new'),
        ),
      ],
    );
  }
}
