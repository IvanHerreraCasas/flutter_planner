import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:flutter_planner/widgets/widgets.dart';

class RoutineNameTextField extends StatelessWidget {
  const RoutineNameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final initialName = context.select(
      (RoutineBloc bloc) => bloc.state.initialRoutine.name,
    );
    return NameTextField(
      initialText: initialName,
      hintText: 'Routine ...',
      onChanged: (name) => context.read<RoutineBloc>().add(
            RoutineNameChanged(name),
          ),
    );
  }
}
