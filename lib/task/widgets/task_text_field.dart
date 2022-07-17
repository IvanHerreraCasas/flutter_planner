import 'package:flutter/material.dart';
import 'package:flutter_planner/planner/planner.dart';
import 'package:flutter_planner/task/task.dart';

class TaskTextField extends StatefulWidget {
  const TaskTextField({
    Key? key,
    required this.initialTitle,
  }) : super(key: key);

  final String initialTitle;

  @override
  State<TaskTextField> createState() => _TaskTextFieldState();
}

class _TaskTextFieldState extends State<TaskTextField> {
  late final TextEditingController controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialTitle);
    focusNode = FocusNode();
    if (widget.initialTitle.isEmpty) {
      focusNode.requestFocus();
    }

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        final title = context.read<TaskBloc>().state.title;

        if (title.isNotEmpty) {
          context.read<TaskBloc>().add(const TaskSaved());
        } else {
          context.read<TaskBloc>().add(const TaskDeleted());
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      onChanged: (value) => context.read<TaskBloc>().add(
            TaskTitleChanged(value),
          ),
      onEditingComplete: () {
        if (controller.text.isNotEmpty) {
          context.read<PlannerBloc>().add(
                const PlannerNewTaskAdded(),
              );
        } else {
          focusNode.nextFocus();
        }
      },
    );
  }
}
