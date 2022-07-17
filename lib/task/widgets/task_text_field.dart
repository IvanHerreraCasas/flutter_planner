import 'package:flutter/material.dart';
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
    );
  }
}
