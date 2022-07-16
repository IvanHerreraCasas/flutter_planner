import 'package:flutter/material.dart';
import 'package:flutter_planner/task/task.dart';

class TaskTextField extends StatelessWidget {
  const TaskTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = context.select((TaskBloc bloc) => bloc.state.title);
    return TextField(
      controller: TextEditingController(text: title),
      onChanged: (value) => context.read<TaskBloc>().add(
            TaskTitleChanged(value),
          ),
    );
  }
}
