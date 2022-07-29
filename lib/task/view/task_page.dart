import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/task/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 1 / 8,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Theme.of(context).colorScheme.surface,
            onPressed: (context) => context.read<TaskBloc>().add(
                  const TaskDeleted(),
                ),
            icon: Icons.delete,
          )
        ],
      ),
      child: Row(
        children: [
          const TaskCheckBox(),
          Expanded(
            child: TaskTextField(
              initialTitle: context.read<TaskBloc>().state.initialTask.title,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
