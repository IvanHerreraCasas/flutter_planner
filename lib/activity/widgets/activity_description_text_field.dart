import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';

class ActivityDescriptionTextField extends StatelessWidget {
  const ActivityDescriptionTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialDescription = context.select(
      (ActivityBloc bloc) => bloc.state.initialActivity.description,
    );
    
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color.fromARGB(255, 194, 193, 193),
        ),
      ),
      child: TextField(
        minLines: 2,
        maxLines: 5,
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
