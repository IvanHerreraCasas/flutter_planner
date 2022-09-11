import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';

class ActivityDescriptionTextField extends StatelessWidget {
  const ActivityDescriptionTextField({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final ActivitySize currentSize;

  @override
  Widget build(BuildContext context) {
    final initialDescription = context.select(
      (ActivityBloc bloc) => bloc.state.initialActivity.description,
    );

    final isSmall = currentSize == ActivitySize.small;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 194, 193, 193),
        ),
      ),
      child: TextField(
        minLines: isSmall ? 1 : null,
        maxLines: isSmall ? 10 : null,
        expands: !isSmall,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.all(10),
          hintText: 'Description...',
          fillColor: Colors.transparent,
          hoverColor: Colors.transparent,
          border: InputBorder.none,
        ),
        controller: TextEditingController(
          text: initialDescription,
        ),
        onChanged: (value) => context.read<ActivityBloc>().add(
              ActivityDescriptionChanged(value),
            ),
      ),
    );
  }
}
