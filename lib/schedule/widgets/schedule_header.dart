import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_planner/app/router/router.dart';
import 'package:flutter_planner/schedule/schedule.dart';
import 'package:go_router/go_router.dart';
import 'package:routines_api/routines_api.dart';

class ScheduleHeader extends StatelessWidget {
  const ScheduleHeader({
    Key? key,
    required this.currentSize,
  }) : super(key: key);

  final ScheduleSize currentSize;

  void _onAdd({required BuildContext context}) {
    final newRoutine = Routine(
      userID: context.read<AuthenticationRepository>().user!.id,
      name: '',
      day: 1,
      startTime: DateTime(1970, 1, 1, 7),
      endTime: DateTime(1970, 1, 1, 9),
    );
    if (currentSize == ScheduleSize.large) {
      context
          .read<ScheduleBloc>()
          .add(ScheduleSelectedRoutineChanged(newRoutine));
    } else {
      context.goNamed(
        AppRoutes.routine,
        params: {'page': 'schedule'},
        extra: newRoutine,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 20),
        Text(
          'Schedule',
          style: Theme.of(context).textTheme.headline5,
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: () => _onAdd(context: context),
          child: const Text('Add'),
        ),
        const SizedBox(width: 20),
      ],
    );
  }
}
