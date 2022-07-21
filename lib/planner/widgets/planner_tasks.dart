import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';

class PlannerTasks extends StatelessWidget {
  const PlannerTasks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((PlannerBloc bloc) => bloc.state.tasks);

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskWidget(
        key: ValueKey(tasks[index]),
        task: tasks[index],
      ),
    );
  }
}
