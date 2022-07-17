import 'package:flutter/material.dart';
import 'package:flutter_planner/task/bloc/bloc.dart';
import 'package:flutter_planner/task/widgets/widgets.dart';
import 'package:tasks_repository/tasks_repository.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget({
    Key? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(
        initialTask: task,
        tasksRepository: context.read<TasksRepository>(),
      ),
      child: const TaskView(),
    );
  }
}

class TaskView extends StatelessWidget {
  const TaskView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TaskCheckBox(),
        Expanded(
          child: TaskTextField(
            initialTitle: context.read<TaskBloc>().state.initialTask.title,
          ),
        ),
      ],
    );
  }
}
