import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/task/task.dart';

class TaskCheckBox extends StatelessWidget {
  const TaskCheckBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = context.select(
      (TaskBloc bloc) => bloc.state.isCompleted,
    );

    return Checkbox(
      value: isCompleted,
      onChanged: (_) => context.read<TaskBloc>().add(
            const TaskCompletetionToggled(),
          ),
    );
  }
}
