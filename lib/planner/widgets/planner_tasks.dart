import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';

class PlannerTasks extends StatefulWidget {
  const PlannerTasks({Key? key}) : super(key: key);

  @override
  State<PlannerTasks> createState() => _PlannerTasksState();
}

class _PlannerTasksState extends State<PlannerTasks> {
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();

    _controller = ScrollController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = context.select((PlannerBloc bloc) => bloc.state.tasks);

    return ListView.builder(
      controller: _controller,
      itemCount: tasks.length,
      itemBuilder: (context, index) => TaskWidget(
        key: ValueKey(tasks[index]),
        task: tasks[index],
      ),
    );
  }
}
