import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/routine/routine.dart';
import 'package:go_router/go_router.dart';

class RoutineHeaderButtons extends StatelessWidget {
  const RoutineHeaderButtons({
    Key? key,
    required this.isPage,
  }) : super(key: key);

  final bool isPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isPage)
          IconButton(
            onPressed: () => context.pop(),
            splashRadius: 10,
            icon: const Icon(Icons.arrow_back),
          ),
        const Spacer(),
        ElevatedButton(
          onPressed: () =>
              context.read<RoutineBloc>().add(const RoutineSaved()),
          child: const Text('Save'),
        ),
        const SizedBox(width: 5),
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'delete') {
              context.read<RoutineBloc>().add(const RoutineDeleted());
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Text(
                'Delete',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
