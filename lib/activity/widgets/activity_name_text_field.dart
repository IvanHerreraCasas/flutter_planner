import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/activity/activity.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class ActivityNameTextField extends StatelessWidget {
  const ActivityNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialName = context.select(
      (ActivityBloc bloc) => bloc.state.initialActivity.name,
    );

    return NameTextField(
      initialText: initialName,
      hintText: 'Activity ...',
      onChanged: (value) => context.read<ActivityBloc>().add(
            ActivityNameChanged(value),
          ),
    );
  }
}
